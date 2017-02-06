Discovery Incremental Search
----------------------------

By using the Asset Discovery Spatial Search method we can quickly get assets data on GeoJSON format. The following request method allows to filter the assets by location. Either by spatial coordinates or simply by providing the name of the cities involved in the OC project.

```GET http://discovery.organicity.eu/v0/assets/geo/search?city=london```

Since the response is formatted on the GeoJSON standard we this allows to quickly build map visualizations by using libraries as Leaflet. By combining the API request with a pre existing UI for building map modules we can create a basic geographic engine for any assets collection easily.

[Demo](http://codepen.io/pral2a/pen/NRgakY)