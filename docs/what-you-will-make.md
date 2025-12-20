# What you will make

If you work through this class, you will create a fast and free interactive map of the world that can display whatever data you'd like.

This type of map is often called a "basemap" because it provides a foundation for displaying data layers like weather conditions, election results, demographics or the location of newsworthy events.

Here's an example of the basemap that [Reuters](https://www.reuters.com/) developed using the techniques you'll learn in this class. The news organization uses it to display hurricane paths, climate data and other data-driven journalism.

```{raw} html
<div style="width: 100%; height: 400px; position: relative;">
    <div id="demo-map" style="position: absolute; top: 0; bottom: 0; left: 0; right: 0;"></div>
</div>
<script src="https://unpkg.com/maplibre-gl@5.5.0/dist/maplibre-gl.js"></script>
<link href="https://unpkg.com/maplibre-gl@5.5.0/dist/maplibre-gl.css" rel="stylesheet">
<script>
    const map = new maplibregl.Map({
        container: 'demo-map',
        style: '_static/reuters.json',
        center: [-98.5795, 39.8283],
        zoom: 1,
        minZoom: 1,
        maxZoom: 15,
        attributionControl: false
    });

    let userInteracting = false;
    const secondsPerRevolution = 120;
    const maxSpinZoom = 5;
    const slowSpinZoom = 3;

    function spinGlobe() {
        const zoom = map.getZoom();
        if (!userInteracting && zoom < maxSpinZoom) {
            let distancePerSecond = 360 / secondsPerRevolution;
            if (zoom > slowSpinZoom) {
                const zoomDif = (maxSpinZoom - zoom) / (maxSpinZoom - slowSpinZoom);
                distancePerSecond *= zoomDif;
            }
            const center = map.getCenter();
            center.lng -= distancePerSecond / 60;
            map.easeTo({ center, duration: 1000, easing: n => n });
        }
    }

    map.on('style.load', () => {
        map.setProjection({ type: 'globe' });
        map.on('mousedown', () => { userInteracting = true; });
        map.on('dragstart', () => { userInteracting = true; });
        map.on('touchstart', () => { userInteracting = true; });
        map.on('wheel', () => { userInteracting = true; });

        spinGlobe();
        setInterval(spinGlobe, 1000);
    });
</script>
```

## Why you should care

Until recently, creating a basemap was a difficult task that required specialized skills and expensive servers. Rather than take on the challenge, many organizations chose to pay for access to commercial mapping services, which can be costly for applications that draw a lot of traffic.

Then open-source software changed the equation.

The new [PMTiles](https://github.com/protomaps/PMTiles) file format allowed, for the first time, for the massive database needed to render a detailed map of the world to be stored and served efficiently from a single file.

That meant that instead of needing a complex, fragile server setup to render maps, you could rely on an inexpensive static file service. Suddenly, all it took to escape an expensive mapping contract was be to convert the free-and-open [OpenStreetMap](https://www.openstreetmap.org/) data that powers many commercial maps to the free alternative format.

This class will show you how to you can do just that using open-source tools and low-cost cloud-computing services. Once you're done, your only ongoing cost will be hosting a single file on [Amazon S3](https://aws.amazon.com/s3/) or a competitor, which can be done for just a few dollars a month.

It will take a lot of different tools to get the job done, but none of them are difficult to use and we'll proceed slowly, step-by-step. Ready?
