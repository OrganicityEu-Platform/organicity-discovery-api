$(document).ready(function() {
    var myMap = L.map('map');
    var assetsLayer = new L.geoJson();
    assetsLayer.addTo(myMap);

    L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
        id: 'mapbox.streets-basic',
        accessToken: 'pk.eyJ1IjoidG9tYXNkaWV6IiwiYSI6ImRTd01HSGsifQ.loQdtLNQ8GJkJl2LUzzxVg'
    }).addTo(myMap);

    $.getJSON("http://discovery.organicity.eu/v0/assets/geo/search?city=london&limit=1000", function(layers) {
        $(layers).each(function(key, data) {
            $(layers[key].features).each(function(key, data) {
                assetsLayer.addData(data);
            });
        });

        myMap.fitBounds(assetsLayer.getBounds());

    });
});