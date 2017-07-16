##############################################################################
#	
##############################################################################

@CLASS
ActiveModelSerializer

@OPTIONS
locals



##############################################################################
@serialize[mObject;bWithAttributes;bWithRelationships]
    $result[^json:string[
        $.data[^ActiveModelSerializer:prepareHash[$mObject]($bWithAttributes;$bWithRelationships)]
    ][
        $._default[$array:json]
        $.void[null]
    ]]
#end @serialize[]



##############################################################################
@prepareHash[mObject;bWithAttributes;bWithRelationships]
    ^switch[$mObject.CLASS_NAME]{
        ^case[array]{
            $result[^ActiveModelSerializer:prepareArrayHash[$mObject]($bWithAttributes;$bWithRelationships)]
        }

        ^case[DEFAULT]{
            $result[^ActiveModelSerializer:prepareObjectHash[$mObject]($bWithAttributes;$bWithRelationships)]
        }
    }
#end @prepareHash[]



##############################################################################
@prepareArrayHash[aObject;bWithAttributes;bWithRelationships]
    $result[^array::create[]]

    ^foreach[$aObject;item]{
        ^result.add[^ActiveModelSerializer:prepareHash[$item]($bWithAttributes;$bWithRelationships)]
    } 
#end @prepareArrayHash[]



##############################################################################
@prepareObjectHash[oObject;bWithAttributes;bWithRelationships]
    $result[^hash::create[]]

    ^if($oObject.id){
       $result.id[$oObject.id] 
    }

    $result.type[$oObject.table_name]

    ^if($bWithAttributes){
        $result.attributes[^hash::create[]]
    
        $primary_key[${oObject.table_name}_id]

        ^oObject.attributes.foreach[field;value]{
            ^if($field eq "id" || $field eq $primary_key){ ^continue[] }

            ^if($field eq "type"){
                $field[${result.type}_type]
            }

            $result.attributes.[$field][$value]
        }
    }

    ^if($bWithRelationships){
        $result.relationships[^hash::create[]]

       ^oObject.associations.foreach[field;value]{
            ^if($field eq "type"){
                $field[${result.type}_type]
            }

            ^switch[$value.CLASS_NAME]{
                ^case[BelongsToAssociation;HasOneAssociation]{
                    $result.relationships.[$field][$NULL]

                    ^if($value.object){
                        $result.relationships.[$field][^ActiveModelSerializer:prepareObjectHash[$value.object](false;false)]
                    }
                }
            
                ^case[HasManyAssociation;HasAndBelongsToManyAssociation]{
                    $result.relationships.[$field][^ActiveModelSerializer:prepareArrayHash[$value](false;false)]
                }
            }
        }
    }
#end @prepareObjectHash[]