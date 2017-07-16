##############################################################################
@print_field[sField;sTableAlias]
	$result[$sField]
	^if(!^result.match[\.]){
		$result[${sTableAlias}.${sField}]
	}
#end @print_field[]



##############################################################################
@build_include_params[sValue]
	$result[^hash::create[]]
	
	$index(1)
	$include_hash[$result]
	$values_splited[^sValue.split[.]]
	
	^values_splited.foreach[pos;row]{
		$field[^row.piece.trim[]]
		
		^if($values_splited == $index){
			$include_hash.[$field](true)
			^break[]
		}
		
		$include_hash.[$field][^hash::create[]]
		$include_hash[$include_hash.[$field]]
	
		^index.inc[]
	}
#end @build_include_params[]



##############################################################################
@build_sort_params[sValue]
	$sort_direction[ASC]
	^if(^sValue.match[-]){
		$sort_direction[DESC]
		$sValue[^sValue.replace[-;]]
	}

	$result[
		$.field[$sValue]
		$.direction[$sort_direction]
	]
#end @build_sort_params[]



##############################################################################
@prepare_params[hParams]
	$result[^hash::create[]]
	
	$hParams[^hash::create[$hParams]]
	^hParams.foreach[key;values]{
		$_values[$values]
		
		^if($key eq "sort"){
			$_values[^array::create[]]
			
			^switch[$values.CLASS_NAME]{
				^case[hash]{
					^values.foreach[i;value]{
						^_values.add[^build_sort_params[$value]]
					}					
				}
				^case[string]{
					^_values.add[^build_sort_params[$values]]
				}
			}
		}

		^if($key eq "include"){
			$_values[^hash::create[]]
			
			^switch[$values.CLASS_NAME]{
				^case[hash]{
					^values.foreach[i;value]{
						$_values[^_values.union[^build_include_params[$value]]]
					}					
				}
				^case[string]{
					$_values[^_values.union[^build_include_params[$values]]]
				}
			}
		}		
		
		$result.[$key][$_values]
	}
#end @prepare_params[]



##############################################################################
@deep_clone[mObject][key;value]
	^if($mObject is hash){
		$result[^hash::create[]]
		
		^mObject.foreach[key;value]{
			$result.[$key][^deep_clone[$value]]
		}
	}($mObject is array){
		$result[^array::create[]]
		
		^foreach[$mObject;value]{
			^result.add[^deep_clone[$value]]
		}
	}{
		$result[$mObject]
	}
#end @deep_clone[hHash]



##############################################################################
@update_item_with_attributes[oItem;hParams]
    ^if(def $hParams.attributes){
        ^oItem.update[$hParams.attributes]
    }
    
    ^if(def $hParams.relationships){
        ^hParams.relationships.foreach[association;data]{
            $association_value[$oItem.[$association]]

            ^if(!def $association_value){ ^continue[] }
            
            ^switch[$association_value.CLASS_NAME]{
                ^case[BelongsToAssociation;HasOneAssociation]{
                    $association_value[^association_value.mapper.find_by_id(^data.data.id.int(0))]
                
                }
            
                ^case[HasManyAssociation;HasAndBelongsToManyAssociation]{
                    ^foreach[$data.data;data_entity]{
                        ^association_value.add[^association_value.mapper.find_by_id(^data_entity.id.int(0))]
                    }
                }
            }
        }
    }
#end @update_item_with_attributes[]
