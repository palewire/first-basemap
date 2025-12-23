# Creating an interactive map

Now that you've generated PMTiles files and uploaded them to S3, it's time to display them on a web page. We'll use [MapLibre GL JS](https://maplibre.org/maplibre-gl-js/docs/), an open-source library for rendering interactive vector maps in the browser.

## How MapLibre works

MapLibre displays maps by combining two things:

1. **Tile data** — The geographic features (roads, buildings, water, etc.) stored in your PMTiles files
2. **A style file** — A JSON document that tells MapLibre how to draw those features (colors, line widths, fonts, etc.)

The style file is where you'll plug in your PMTiles URLs.

## Get a style file

You could write a style file from scratch, but it's much easier to start with an existing one. [OSM Liberty](https://github.com/maputnik/osm-liberty) is a free, open-source style designed for OpenMapTiles data — exactly what Planetiler produces.

Download the style file from the OSM Liberty repository. You can find it at:

```
https://raw.githubusercontent.com/maputnik/osm-liberty/gh-pages/style.json
```

Save this file as `style.json` in your project.

## Configure the style for PMTiles

Open `style.json` and find the `sources` section near the top. It will look something like this:

```json
"sources": {
  "openmaptiles": {
    "type": "vector",
    "url": "https://tiles.example.com/{z}/{x}/{y}.pbf"
  }
}
```

Replace the URL with your PMTiles file, using the special `pmtiles://` protocol prefix:

```{code-block} json
---
emphasize-lines: 4
---
"sources": {
  "openmaptiles": {
    "type": "vector",
    "url": "pmtiles://https://your-bucket.s3.amazonaws.com/planet-TIMESTAMP-base.pmtiles"
  }
}
```

The `pmtiles://` prefix tells MapLibre to use the PMTiles protocol adapter, which knows how to fetch tile data from a single PMTiles file using HTTP range requests.

:::{note}
Replace `your-bucket` with your actual S3 bucket name, and `TIMESTAMP` with the timestamp from your generated file (e.g., `planet-20251221-185206-base.pmtiles`).
:::

### Add a buildings source

Our Planetiler workflow generated two separate PMTiles files — one for the base map and one for buildings. To display 3D buildings, you need to add a second source:

```{code-block} json
---
emphasize-lines: 6-9
---
"sources": {
  "openmaptiles": {
    "type": "vector",
    "url": "pmtiles://https://your-bucket.s3.amazonaws.com/planet-TIMESTAMP-base.pmtiles"
  },
  "buildings": {
    "type": "vector",
    "url": "pmtiles://https://your-bucket.s3.amazonaws.com/planet-TIMESTAMP-buildings.pmtiles"
  }
}
```

### Update layer source references

The style file contains many layers, and each layer specifies which source it pulls data from using the `"source"` property. Most layers reference `"openmaptiles"`, but the building layers need to reference your new `"buildings"` source.

Search for layers with `"source-layer": "building"` in your style file. You'll find layers like these:

```json
{
  "id": "building",
  "type": "fill",
  "source": "buildings",
  "source-layer": "building",
  ...
},
{
  "id": "building-3d",
  "type": "fill-extrusion",
  "source": "buildings",
  "source-layer": "building",
  ...
}
```

Make sure the `"source"` property for these building layers points to `"buildings"` (your new source name), not `"openmaptiles"`.

:::{tip}
The `"source"` property tells MapLibre which tile source to read from, while `"source-layer"` specifies which layer *within* that source contains the data. Since our buildings PMTiles file has a layer called `"building"`, we set `"source": "buildings"` and `"source-layer": "building"`.
:::

## Create the HTML page

Create an `index.html` file with the following code:

```{code-block} html
---
emphasize-lines: 17-18
---
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>My First Basemap</title>
    <script src="https://unpkg.com/maplibre-gl@5.0.1/dist/maplibre-gl.js"></script>
    <link href="https://unpkg.com/maplibre-gl@5.0.1/dist/maplibre-gl.css" rel="stylesheet">
    <script src="https://unpkg.com/pmtiles@4.0.1/dist/pmtiles.js"></script>
    <style>
        body { margin: 0; }
        #map { width: 100vw; height: 100vh; }
    </style>
</head>
<body>
    <div id="map"></div>
    <script>
        let protocol = new pmtiles.Protocol();
        maplibregl.addProtocol('pmtiles', protocol.tile);

        const map = new maplibregl.Map({
            container: 'map',
            style: 'style.json',
            center: [0, 20],
            zoom: 1.5,
            projection: { type: 'globe' }
        });
    </script>
</body>
</html>
```

The highlighted lines register the PMTiles protocol with MapLibre. This is required for the `pmtiles://` URLs in your style file to work.

## Understanding the code

Let's break down what's happening:

- **Lines 6-8**: Load the MapLibre GL JS library, its CSS, and the PMTiles JavaScript library from CDN
- **Lines 17-18**: Register the PMTiles protocol adapter so MapLibre can read PMTiles files
- **Lines 20-26**: Create a new map instance with:
  - `container`: The HTML element ID where the map will render
  - `style`: Path to your modified style file
  - `center`: Starting longitude and latitude
  - `zoom`: Starting zoom level
  - `projection`: Set to `'globe'` for a 3D globe view

## Test locally

To test your map, you'll need to serve the files through a local web server. Opening the HTML file directly won't work due to browser security restrictions.

If you have Python installed, the easiest method is:

```bash
python -m http.server 8000
```

Then open `http://localhost:8000` in your browser. You should see your basemap rendered as an interactive globe.

:::{admonition} Troubleshooting
:class: tip

If the map doesn't appear:
- Check your browser's developer console (F12) for errors
- Verify your PMTiles URL is correct and publicly accessible
- Ensure the `style.json` file is in the same directory as your HTML file
:::

In the next chapter, we'll learn how to publish your map to the web using GitHub Pages.
