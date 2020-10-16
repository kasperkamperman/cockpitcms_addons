<?php

$app->on('admin.init', function() {
    $this->helper('admin')->addAssets('geojsonlocation:assets/components/field-geojsonlocation.tag');
    $this->helper('admin')->addAssets([
        'geojsonlocation:assets/css/leaflet.css',
        'geojsonlocation:assets/js/leaflet.js',
    ]);
    $this->helper('admin')->addAssets([
        'geojsonlocation:assets/js/places.min.js',
    ]);
});
