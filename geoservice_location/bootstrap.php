<?php

// ADMIN
if (COCKPIT_ADMIN && !COCKPIT_API_REQUEST) {
    $app->on('admin.init', function() {
    $this->helper('admin')->addAssets('geoservice_location:assets/components/field-geoservice_location.tag');
    $this->helper('admin')->addAssets([
        'geoservice_location:assets/css/leaflet.css',
        'geoservice_location:assets/js/leaflet.js',
    ]);
});
}
