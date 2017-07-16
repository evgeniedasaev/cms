##############################################################################
#	
##############################################################################

@CLASS
ResourceObject

@OPTIONS
locals



##############################################################################
@create[mObject;hCollection]
    $self._object[$mObject]
    $self._collection[^hash::create[$hCollection]]
#end @create[]



##############################################################################
@GET_primary_key[]
    $result[${self._object.table_name}_id]
#end @GET_primary_key[]



##############################################################################
@GET_id[]
    $result[]

    ^if($self._object && $self._object.[$self.primary_key]){
       $result[$self._object.[$self.primary_key]] 
    }
#end @GET_id[]



##############################################################################
@GET_type[]
    $result[]

    ^if($self._object){
       $result[$self._object.table_name] 
    }
    
    ^if($result eq 'object'){
        $result[category]
    }
#end @GET_type[]



##############################################################################
@GET_attributes[]
    $result[^hash::create[]]

    ^if($self._object){
        $fields[^array::create[$self._collection._fields.[$self._object.table_name]]]
        $fields[^fields.hash[]]

        $primary_key[${self._object.table_name}_id]
        
        ^if($self._object.prepare_for_api is junction){
            $_attributes[^self._object.prepare_for_api[]]
        }{
            $_attributes[$self._object.attributes]
        }

        ^_attributes.foreach[field;value]{
            ^if($field eq "id" || $field eq $self.primary_key){ ^continue[] }
            ^if($fields && !def $fields.[$field]){ ^continue[] }

            ^if($field eq "type"){
                $field[${result.type}_type]
            }

            $result.[$field][$value]
        }
    }
#end @GET_attributes[]



##############################################################################
@GET_relationships[]
    $result[^hash::create[]]

    ^if($self._object){        
        ^self._object.associations.foreach[field;value]{
            $original_field[$field]
            ^if($field eq "type"){
                $field[${result.type}_type]
            }
            
            $result.[$field][
                $.links[
                    $.self[^LinkObject::create[$self._object.table_name;fetch_relationships][
                        $.id[$self._object.id]
                        $.relationship[$original_field]
                    ]]
                ]
            ]
            
            ^if(!def $self._collection._include.[$original_field]){^continue[]}

            ^switch[$value.CLASS_NAME]{
                ^case[BelongsToAssociation;HasOneAssociation]{
                    $result.[$field].data[$NULL]

                    ^if($value.object){
                        $result.[$field].data[^ResourceObject::create[$value.object][
                            $._with_attributes(false)
                            $._with_relationships(false)
                        ]]
                    }
                }
            
                ^case[HasManyAssociation;HasAndBelongsToManyAssociation]{
                    $result.[$field].data[^array::create[]]

                    ^if($value){
                        ^foreach[$value;object]{
                            ^result.[$field].data.add[^ResourceObject::create[$object][
                                $._with_attributes(false)
                                $._with_relationships(false)
                            ]]               
                        }
                    }
                }
            }
        }
    }
#end @GET_relationships[]



##############################################################################
@GET_data[]
    $result[
        $.type[$self.type]
        ^if($self.id){
            $.id[$self.id]
        }
        ^if($self._collection._with_attributes){
            $.attributes[$self.attributes]
        }
        ^if($self._collection._with_relationships){
            $.relationships[$self.relationships]
        }
    ]
#end @GET_data[]



##############################################################################
@static:json[key;resource_object;options]
    $result[^json:string[$resource_object.data][$options]]
#end @static:json[]