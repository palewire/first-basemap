# Python short cuts
UV := uv run
PYTHON := python -W ignore -m

# Configuration - change these for different countries/regions
COUNTRY = global
YEAR = 2020

# Global mosaic URL (entire planet in one file!)
WORLDPOP_URL = https://data.worldpop.org/GIS/Population/Global_2000_2020/$(YEAR)/0_Mosaicked/ppp_$(YEAR)_1km_Aggregated.tif

# Output files
RASTER = worldpop_$(COUNTRY)_$(YEAR).tif
CLASSIFIED_RASTER = worldpop_$(COUNTRY)_$(YEAR)_classified.tif
POLYGONS = worldpop_$(COUNTRY)_$(YEAR)_polygons.geojson
POLYGONS_PMTILES = worldpop_$(COUNTRY)_$(YEAR)_polygons.pmtiles

AWS_PROFILE = faq
S3_BUCKET = first-basemap

# Default target
all: $(POLYGONS_PMTILES)
	@echo ""
	@echo "✓ Done! Your PMTiles file is ready:"
	@echo "  Polygons: $(POLYGONS_PMTILES)"
	@echo ""
	@echo "MapLibre usage (polygons for filled areas):"
	@echo "  map.addSource('population-polygons', {"
	@echo "    type: 'vector',"
	@echo "    url: 'pmtiles://./$(POLYGONS_PMTILES)'"
	@echo "  });"

check:
	@echo "Checking dependencies..."
	@command -v curl >/dev/null 2>&1 || (echo "ERROR: curl not found" && exit 1)
	@command -v gdal_calc.py >/dev/null 2>&1 || (echo "ERROR: GDAL Python tools not found" && exit 1)
	@command -v gdal_polygonize.py >/dev/null 2>&1 || (echo "ERROR: GDAL Python tools not found" && exit 1)
	@command -v tippecanoe >/dev/null 2>&1 || (echo "ERROR: tippecanoe not found" && exit 1)
	@command -v aws >/dev/null 2>&1 || (echo "ERROR: aws cli not found" && exit 1)
	@echo "✓ All dependencies found!"

# Download WorldPop raster
$(RASTER):
	@echo "Downloading WorldPop GLOBAL data for $(YEAR)..."
	@echo "⚠️  WARNING: This is a large file (~700MB), may take several minutes"
	curl -L --progress-bar -o $@ "$(WORLDPOP_URL)"
	@echo "Verifying download..."
	@gdalinfo $@ > /dev/null || (echo "ERROR: Invalid GeoTIFF!" && exit 1)
	@echo "✓ Download complete"

# Classify raster into discrete bins for polygonization
$(CLASSIFIED_RASTER): $(RASTER)
	@echo "Classifying population into bins..."
	@echo "⚠️  This may take several minutes for global data"
	gdal_calc.py -A $(RASTER) --outfile=$@ \
		--calc="1*(A>=1)*(A<1000) + 2*(A>=1000)*(A<5000) + 3*(A>=5000)*(A<10000) + 4*(A>=10000)*(A<25000) + 5*(A>=25000)*(A<50000) + 6*(A>=50000)*(A<100000) + 7*(A>=100000)*(A<250000) + 8*(A>=250000)" \
		--NoDataValue=0 --type=Byte --co COMPRESS=LZW
	@echo "✓ Classification complete"

# Helper script for adding population attributes
define ADD_POPULATION_SCRIPT
import json
import sys
with open(sys.argv[1], 'r') as f:
	data = json.load(f)
class_map = {1: 1, 2: 1000, 3: 5000, 4: 10000, 5: 25000, 6: 50000, 7: 100000, 8: 250000}
for feat in data['features']:
	cls = feat['properties'].get('DN', 0)
	feat['properties']['population'] = class_map.get(cls, 0)
	feat['properties']['pop_class'] = cls
with open(sys.argv[1], 'w') as f:
	json.dump(data, f)
endef
export ADD_POPULATION_SCRIPT

# Convert classified raster to polygons
$(POLYGONS): $(CLASSIFIED_RASTER)
	@echo "Converting raster to polygons..."
	@echo "⚠️  This will take 10-20 minutes for global data"
	gdal_polygonize.py $(CLASSIFIED_RASTER) -f "GeoJSON" $@ population_class DN
	@echo "Adding population range attributes..."
	@python3 -c "$$ADD_POPULATION_SCRIPT" $@
	@echo "✓ Created $(POLYGONS)"

# Create PMTiles from polygons
$(POLYGONS_PMTILES): $(POLYGONS)
	@echo "Creating polygons PMTiles with tippecanoe..."
	@echo "⚠️  This may take 10-20 minutes for global data"
	tippecanoe -o $@ \
		-zg \
		--drop-densest-as-needed \
		--coalesce-densest-as-needed \
		-l population \
		--minimum-zoom=0 \
		--maximum-zoom=8 \
		-n "WorldPop $(COUNTRY) $(YEAR) Polygons" \
		-A "Data from WorldPop" \
		$(POLYGONS)
	@echo "✓ PMTiles created: $$(du -h $(POLYGONS_PMTILES) | cut -f1)"

# Upload PMTiles to S3
upload: $(POLYGONS_PMTILES)
	@echo "Uploading PMTiles to S3..."
	aws s3 cp $(POLYGONS_PMTILES) s3://$(S3_BUCKET)/$(POLYGONS_PMTILES) \
		--profile $(AWS_PROFILE) \
		--content-type "application/vnd.pmtiles" \
		--metadata-directive REPLACE \
		--cache-control "public, max-age=31536000"
	@echo ""
	@echo "✓ Upload complete!"
	@echo "URL: https://$(S3_BUCKET).s3.amazonaws.com/$(POLYGONS_PMTILES)"

# List files in S3 bucket
s3-list:
	@echo "Files in s3://$(S3_BUCKET)/:"
	aws s3 ls s3://$(S3_BUCKET)/ --profile $(AWS_PROFILE) --human-readable --recursive | grep worldpop

# Clean intermediate files
clean:
	rm -f $(RASTER) $(CLASSIFIED_RASTER) $(POLYGONS)

# Clean everything including final PMTiles
distclean: clean
	rm -f $(POLYGONS_PMTILES)

# Serve documentation locally
serve:
	@rm -rf docs/_build
	@cd docs && $(UV) make livehtml

.PHONY: all check upload s3-list clean distclean serve
