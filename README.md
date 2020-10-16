# cockpitcms_addons

## geojsonlocation add-on

geojsonlocation add-on based on the default location field included in Cockpit.

Modifications made:

- Leaflet and Algolia Places files are included in the assets folder and not loaded from unpkg (_speeds up loading of admin_).
- Data is stored in the GeoJSON format.

Versions:

- Leaflet 1.7.1
- Algolia Places 1.19

You don't need to enter API keys for Algolia Places, it supports 1000 requests daily without key.
https://community.algolia.com/places/pricing.html

Algolia Precision is not great, it supports street level precision (4 decimals).
Google Places is more precise, but their license doesn't allow storing lat/lon data.
