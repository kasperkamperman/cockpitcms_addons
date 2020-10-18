<field-geoservice_location>
  <div>
    <div class="uk-form uk-position-relative uk-width-1-1">
      <label for="street">Street Address</label>
      <input
        oninput="{changedField}"
        ref="street"
        name="street"
        class="uk-width-1-1"
      />
      <label for="city">City:</label>
      <input
        oninput="{changedField}"
        ref="city"
        name="city"
        class="uk-width-1-1"
      />
    </div>
    <div
      class="uk-form uk-position-relative uk-width-1-1 uk-margin-bottom uk-margin"
    >
      <div
        class="uk-alert"
        show="{!this.refs.street.value || !this.refs.city.value}"
      >
        Fill in both the Street Address and the City.
      </div>
      <a
        onclick="{getGeoInfo}"
        class="uk-button uk-button-medium uk-button-primary"
      >
        { App.i18n.get('get other data from PDOK Locatieserver') }
      </a>
      <a
        onclick="{getNominatimInfo}"
        class="uk-button uk-button-medium uk-button-primary"
      >
        { App.i18n.get('get other data from OSM Nominatim') }
      </a>
    </div>
    <div class="uk-form uk-position-relative uk-width-1-1">
      <label for="postcode">Postcode:</label>
      <input
        oninput="{changedField}"
        ref="postcode"
        name="postcode"
        class="uk-width-1-1"
      />
      <label for="province">Province:</label>
      <input
        oninput="{changedField}"
        ref="province"
        name="province"
        class="uk-width-1-1"
      />
      <label for="country">Country Code:</label>
      <input
        oninput="{changedField}"
        ref="countrycode"
        name="countrycode"
        class="uk-width-1-1"
        maxlength="2"
      />
    </div>
    <div class="uk-form uk-position-relative uk-width-1-1 uk-margin">
      <div ref="map" style="min-height: 300px; z-index: 0">Loading map...</div>
    </div>
  </div>

  <script>
    /*
        - modified version of field-location, uses geojson.
        - geojson feature is used to store address prorties.
        - two geo services can be used to lookup information.
        - PDOK Locatieserver. Public Location data server of The Netherlands:
          https://www.pdok.nl/introductie/-/article/pdok-locatieserver
        - Nominatim. Search API that searches Open StreetMap Data:
          https://nominatim.openstreetmap.org/ui/search.html
        - debounce is added so both API's are not contacted more then once each second.
        - the API's are used instead of Algolia Places, because Algolia only contains geo data on
          streetlevel and not on housenumber.
    */
    var locale = document.documentElement.lang.toUpperCase();

    var $this = this;

    this.marker = null;
    this.map = null;

    //order in geojson: longitude, latitude
    var geodefaultpos = {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [0.0, 0.0],
      },
      properties: {
        street: "",
        city: "",
        postcode: "",
        province: "",
        countrycode: ""
      },
    };

    this.geoPoint = geodefaultpos;

    this.$updateValue = function (value) {

      // fill in empty data when a new entry is made
      if (!value) {
        value = geodefaultpos;
      }

      // fill in existing data when opening and exisiting entry
      if (this.geoPoint != value) {
        this.geoPoint = value;

        var props = this.geoPoint.properties;
        var refs  = this.refs;

        refs.street.value = props.street;
        refs.city.value = props.city;
        refs.postcode.value = props.postcode;
        refs.province.value = props.province;
        refs.countrycode.value = props.countrycode;

        this.update();
      }
    }.bind(this);

    changedField(e) {
      debouncedUpdateFields(e.target);
    };

    var debouncedUpdateFields = _.debounce(function (target) {

      var props = $this.geoPoint.properties;

      switch(target.name) {
        case "street": props.street = target.value;
        break;
        case "city": props.city = target.value;
        break;
        case "postcode": props.postcode = target.value;
        break;
        case "province": props.province = target.value;
        break;
        case "countrycode": props.countrycode = target.value;
        break;
      }

      $this.$setValue($this.geoPoint);
      }, 300);

    getGeoInfo() {
      if($this.refs.street.value && $this.refs.city.value) debouncedGetGeoInfo();
    }

    var debouncedGetGeoInfo = _.debounce(function() {

      var query = $this.refs.street.value + ", " + $this.refs.city.value;

      //$.get("https://geodata.nationaalgeoregister.nl/locatieserver/v3/free?rows=1&fq=type:adres%20&q="+query, function (data) {
      $.get("https://geodata.nationaalgeoregister.nl/locatieserver/v3/free?rows=1&fl=centroide_ll,postcode,provincienaam&fq=type:adres%20&q=" + query, function (data) {

          //console.log(data.response.docs);
          var point = data.response.docs[0].centroide_ll;
          var str_to_array = point.match(/\((.*)\)/)[1].split(' ');
          var latlng = { lat: parseFloat(str_to_array[1]), lng: parseFloat(str_to_array[0]) }

          $this.marker.setLatLng(latlng);

          var geo = $this.marker.toGeoJSON();
          geo.properties = {
            street: $this.refs.street.value,
            city: $this.refs.city.value,
            postcode: data.response.docs[0].postcode,
            province: data.response.docs[0].provincienaam,
            countrycode: "nl"
          };

          $this.$setValue(geo);
          $this.map.panTo($this.marker.getLatLng());
        });
      }, 1000, {
        'leading': true,
        'trailing': false }
    );

    getNominatimInfo() {
        if ($this.refs.street.value && $this.refs.city.value) debouncedGetNominatimInfo();
      };

      var debouncedGetNominatimInfo = _.debounce(function () {

        var query = encodeURI($this.refs.street.value + ", " + $this.refs.city.value);

        $.get("https://nominatim.openstreetmap.org/?addressdetails=1&format=json&limit=1&q=" + query, function (data) {

          //console.log(data);

          var latlng = { lat: data[0].lat, lng: data[0].lon }

          $this.marker.setLatLng(latlng);

          var geo = $this.marker.toGeoJSON();
          geo.properties = {
            street: $this.refs.street.value,
            city: $this.refs.city.value || $this.refs.town.value,
            postcode: data[0].address.postcode,
            province: data[0].address.state,
            countrycode: data[0].address.country_code
          };

          $this.$setValue(geo);
          $this.map.panTo($this.marker.getLatLng());
        });
      }, 1000, {
        'leading': true,
        'trailing': false
      }
    );

    this.on("mount", function () {

      var latlng = L.GeoJSON.coordsToLatLng(
        $this.geoPoint.geometry.coordinates
      );

      $this.map = L.map($this.refs.map).setView(latlng, opts.zoomlevel || 14);

      L.tileLayer("https://{s}.tile.osm.org/{z}/{x}/{y}.png", {
        attribution:
          '&copy; <a href="https://osm.org/copyright">OpenStreetMap</a> contributors',
      }).addTo($this.map);

      $this.marker = new L.marker(latlng, {
        draggable: "true",
      });

      $this.marker.on("dragend", function (e) {
        $this.geoPoint.geometry = $this.marker.toGeoJSON().geometry;
        $this.$setValue($this.geoPoint);
      });

      $this.map.addLayer($this.marker);

      $this.update();
    });
  </script>
</field-geoservice_location>
