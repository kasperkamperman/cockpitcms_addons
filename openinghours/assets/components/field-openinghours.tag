
<field-openinghours>

    <div>  
        
        <div class="uk-width-medium-1-1 uk-grid">
      
            <div class="uk-width-medium-1-10">
                <label><i class="uk-icon-calendar"></i> <span class="uk-text-bold">{ App.i18n.get('Date') }</span></label>
            </div>
            <div class="uk-width-medium-2-10">
                <label><span class="uk-text-bold">{ App.i18n.get('Start of season') }</span></label>
                <cp-field type="date" opts="{ { 'format': 'MM-DD', default: '01-01' } }" bind="value.from.date"></cp-field>
            </div>
            <div class="uk-width-medium-2-10">
                <label><span class="uk-text-bold">{ App.i18n.get('End of season') }</span></label>
                <cp-field type="date" opts="{ { 'format': 'MM-DD', default: '12-31' } }" bind="value.to.date"></cp-field>
            </div>
                 
        </div>

        <div class="uk-width-medium-1-1 uk-margin-small-top">
            <div class="uk-alert"><i class="uk-icon-info-circle">&nbsp;&nbsp;</i>
                If there are different openinghours during different seasons, add another openinghours field with another
                date range. Special holidays can be overriden with a special openinghours field.
        
            </div>
        </div>
        
        <div class="uk-margin" each="{entry,idx in dayFields}">
            <cp-field class="uk-display-block uk-margin-small-top" type="{ 'dayopeningtime' }" bind="value.days[{entry}]" opts="{ { 'weekDayNumber': entry } }"></cp-field>
        </div>
    
    </div>

    <hr>
        
        <script>

            var $this = this;

            this._field = null;
            this.set = {};
            this.value = {};
            this.fields = [];

            this.dayFields = [ 0, 1, 2 , 3, 4, 5, 6 ];

            riot.util.bind(this);

            // this.on('mount', function () {

            //     console.log(opts.fields);
 
            //     //opts.fields || [];
            //     this.update();
            // });

            // this.on('update', function () {
            //     this.fields = opts.fields || [];
            // });

            this.$initBind = function () {
                this.root.$value = this.value;
            };

            this.$updateValue = function (value, field) {

                if (!App.Utils.isObject(value) || Array.isArray(value)) {

                    value = {};

                    this.fields.forEach(function (field) {
                        value[field.name] = null;
                    });
                }

                if (JSON.stringify(this.value) != JSON.stringify(value)) {
                    this.value = value;
                    this.update();
                }

                this._field = field;

            }.bind(this);

            this.on('bindingupdated', function () {
                $this.$setValue(this.value);
            });

        </script>

</field-openinghours>
