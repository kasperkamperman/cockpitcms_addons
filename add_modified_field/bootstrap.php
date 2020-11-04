<?php

/*  Add-on to add timestamps to specific fields. 
    The timestamp can be used to track when the field was last modified. 

    Add the collections and fields you would like to track in the array. 
    If the field is an object itself a key "modified" will be added with the timestamp
    If the field is just a value or an array a key is added with the name: "fieldname_modified"

    Thanks to Raffael Jesche for the example and support:
    https://discourse.getcockpit.com/t/track-modification-timestamps-per-field/1698
*/

//$collection['locations'] = ['openinghours', 'company_name'];
//$collection['example_one'] = ['field_one', 'field_two'];
//$collection['example_two'] = ['field_one', 'field_two'];

$app->on("collections.save.before", function ($name, &$entry, $isUpdate) use ($collection) {

    foreach($collection as $collection => $fields) {

        if(!isset($collection)) continue;
        
        if ($name !== $collection) continue;

        foreach($fields as $field) {
            
            if ($isUpdate && isset($entry[$field])) {
                
                // check if the field was updated compared with original entry
                $filter = ['_id' => $entry['_id']];

                $origEntry = $this->module('collections')->findOne($collection, $filter);

                // when there is a change in the specific field, update the timestamp
                if ($entry[$field] !== $origEntry[$field]) {
                    setFieldTimetamp($entry,$field);  
                };
            }
            else {
                // field has to be created
                setFieldTimetamp($entry,$field);            
            }

        }

    }

});

function setFieldTimetamp(&$entry,&$field) {
    // if field is an object (array and assocative_array) add modified key, value to the object
    // else create a new field with name and _modified addition
    if(is_array($entry[$field]) && is_assoc($entry[$field])) {
        $entry[$field][modified] = time();
    }
    else {
        $entry["{$field}_modified"] = time();
    }
}

// https://stackoverflow.com/questions/5996749/determine-whether-an-array-is-associative-hash-or-not
function is_assoc(array $array)
{
    // Keys of the array
    $keys = array_keys($array);

    // If the array keys of the keys match the keys, then the array must
    // not be associative (e.g. the keys array looked like {0:0, 1:1...}).
    return array_keys($keys) !== $keys;
}

?>