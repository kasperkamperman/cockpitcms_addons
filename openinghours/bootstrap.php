<?php

// ADMIN
if (COCKPIT_ADMIN && !COCKPIT_API_REQUEST) {
    $app->on('admin.init', function() {
    $this->helper('admin')->addAssets('openinghours:assets/components/field-dayopeningtime.tag');
    $this->helper('admin')->addAssets('openinghours:assets/components/field-openinghours.tag');
});
}
