<field-dayopeningtime>

    <style>
        label
        {
            display:block;
        }
    </style>

    <div class="uk-grid uk-grid-match uk-grid-gutter uk-margin-small">

      
            <div class="uk-width-medium-1-10">
                <label><i class="uk-icon-clock-o"></i> <span class="uk-text-bold">{ value.day }</span></label>
            </div>
        
            <div class="uk-width-medium-2-10">
                <label><span class="">{ App.i18n.get('Opening') }</span></label>
                <cp-field id="open_field" type="time" bind="value.opens"></cp-field>
            </div>

            
            <div class="uk-width-medium-2-10">
                <label><span class="">{ App.i18n.get('Closing') }</span></label>
                <cp-field id="closes_field" type="time" bind="value.closes"></cp-field>
            </div>

            <div class="uk-width-medium-2-10">
                <label for="{ id }"><span class="">{ App.i18n.get('Closed all day') }</span></label>
                <div>
                    <input id="{ id }" type="checkbox"/>
                </div>
            </div>

            <div class="uk-width-medium-3-10">
                <div>
                    <label><span class="">&nbsp;</span></label>
                    <a onclick="{makeCopy}" class="uk-button uk-button-small uk-button-muted"><i
                            class="uk-icon-copy"></i>&nbsp;copy</a>
                    <a onclick="{pasteCopy}" class="uk-button uk-button-small uk-button-muted"><i class="uk-icon-paste"></i>&nbsp;paste</a>
                </div>
            </div>
    
    </div>

    <script>

        makeCopy() {
            localStorage.setItem('openingtimes', JSON.stringify($this.value));          
        }

        pasteCopy() {
            var pastedValue = JSON.parse(localStorage.getItem('openingtimes'));

            $this.value.opens = pastedValue.opens;
            $this.value.closes = pastedValue.closes;

            if ($this.value.opens != null || $this.value.closes != null) $('#' + $this.id).prop("checked", false);

            $this.$setValue($this.value);
        }


        var $this = this;

        this.id = 'switch' + Math.ceil(Math.random() * 10000000);

        this.value = {};

        // remember
        this.lastValue = {};

        riot.util.bind(this);

        this.dayOfWeek = "bla";

        this.$updateValue = function(value, field) {
            //console.log("updateValue day")

            if (!App.Utils.isObject(value) || Array.isArray(value)) {
                value = { opens: null, closes: null, day: null };
            }

            if (JSON.stringify(this.value) != JSON.stringify(value)) {
                this.value = value;
                this.update();
            }

            //console.log(this.value);

            if (this.value.opens == null && this.value.closes == null) $('#' + $this.id).prop("checked", true);

            

        }.bind(this);

        this.on('bindingupdated', function() {

            //console.log("bindingupdated day");

            // if we enter a value, uncheck box
            // this is jquery but ref attribute can work too
            //this.refs.input.setAttribute('required', 'required');
            if(this.value.opens != null || this.value.closes !=null ) $('#' + $this.id).prop("checked", false);
            
            $this.$setValue(this.value);
        });

        this.on("mount", function () {

            //console.log("mount day");
            if (opts.weekDayNumber !== undefined && opts.weekDayNumber !== null) {
                //var weekday = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
                var weekdayShort = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                this.value.day = weekdayShort[opts.weekDayNumber];
                //console.log(opts.weekDayNumber + ":" + this.value.dayOfWeek);
                this.update();
            }
            
        });

         $(document).ready(function () {
      
             $('#' + $this.id).change(function () {

                //console.log("checkbox changed:"+ $this.id);

                 if ($(this).is(':checked')) {
                    // remember values already filled in by making a copy
                    $this.lastValue = Object.assign({}, $this.value);
                    $this.value.opens = null;
                    $this.value.closes = null;
                    $this.$setValue($this.value);
                 } 
                 else {
                    // put remembered values back
                    if(!jQuery.isEmptyObject($this.lastValue)) {
                        $this.value = $this.lastValue;
                        $this.$setValue($this.value);
                    }
                 }
             });
        });

    </script>

</field-dayopeningtime>
