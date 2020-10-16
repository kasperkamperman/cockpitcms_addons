<field-geojsonlocation>
  <div>
    <div
      class="uk-form uk-position-relative uk-margin-small-bottom uk-width-1-1"
      style="z-index: 1001"
    >
      <input
        ref="autocomplete"
        class="uk-width-1-1"
        placeholder="{ geoPoint.properties.address || [geoPoint.geometry.coordinates[1], geoPoint.geometry.coordinates[0]].join(', ') }"
      />
    </div>
    <div ref="map" style="min-height: 300px; z-index: 0">Loading map...</div>
  </div>

  <script>
    /* 
        modified version of field-location
        uses now geojson format. I've used a feature to store the address properties
        so the field can be pre-filled with the address
    */

    var map, marker;

    var locale = document.documentElement.lang.toUpperCase();

    var $this = this;

    //order in geojson: longitude, latitude

    var geodefaultpos = {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [9.9986523, 53.5590986],
      },
      properties: {
        address: "",
      },
    };

    this.geoPoint = geodefaultpos;

    this.$updateValue = function (value) {
      if (!value) {
        value = geodefaultpos;
      }

      if (this.geoPoint != value) {
        this.geoPoint = value;

        if (marker) {
          marker.setLatLng(
            L.GeoJSON.coordsToLatLng(
              this.geoPoint.geometry.coordinates
            ).update()
          );
          map.panTo(marker.getLatLng());
        }

        this.update();
      }
    }.bind(this);

    this.on("mount", function () {
      setTimeout(function () {
        var latlng = L.GeoJSON.coordsToLatLng(
          $this.geoPoint.geometry.coordinates
        );

        var map = L.map($this.refs.map).setView(latlng, opts.zoomlevel || 13);

        L.tileLayer("https://{s}.tile.osm.org/{z}/{x}/{y}.png", {
          attribution:
            '&copy; <a href="https://osm.org/copyright">OpenStreetMap</a> contributors',
        }).addTo(map);

        var marker = new L.marker(latlng, {
          draggable: "true",
        });

        marker.on("dragend", function (e) {
          $this.$setValue(marker.toGeoJSON());
        });

        map.addLayer(marker);

        var pla = places({
          //appId: "<your Algolia appId>",
          //apiKey: "<your Algolia apiKey>",
          container: $this.refs.autocomplete,
        })
          .on("change", function (e) {
            marker.setLatLng(e.suggestion.latlng).update();

            var geo = marker.toGeoJSON();
            geo.properties.address = e.suggestion.value;

            $this.$setValue(geo);
            map.panTo(marker.getLatLng());

            pla.close();
            pla.setVal("");
          })
          .on("suggestions", function (e) {
            var coords = e.query.match(
              /^(\-?\d+(?:\.\d+)?),\s*(\-?\d+(?:\.\d+)?)$/
            );

            if (!coords) {
              return;
            }

            var latlng = {
              lat: parseFloat(coords[1]),
              lng: parseFloat(coords[2]),
            };

            marker.setLatLng(latlng).update();
            $this.$setValue(marker.toGeoJSON());
            map.panTo(marker.getLatLng());

            pla.close();
            pla.setVal("");
          });
      }, 50);

      $this.update();
    });
  </script>
</field-geojsonlocation>
