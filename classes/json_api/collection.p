##############################################################################
#	
##############################################################################

@CLASS
Collection

@OPTIONS
locals



##############################################################################
@create[hOptions]
    $hOptions[^hash::create[$hOptions]]

    $self._with_attributes(^hOptions.with_attributes.bool(false))
    $self._with_relationships(^hOptions.with_relationships.bool(false))

    $self._included[^array::create[]]
    $self._links[^hash::create[]]
    $self._errors[^array::create[]]
    $self._meta[^hash::create[]]   

    ^if($hOptions.version){
        $self._jsonapi[
            $.version[$hOptions.version]
        ]
    }
#end @create[]



##############################################################################
@SET_field[hField]
    $self._fields[^hash::create[$hField]]
#end @SET_field[]



##############################################################################
@SET_include[hInclude]
    $self._include[^hash::create[$hInclude]]
#end @SET_include[]



##############################################################################
@SET_page[hPage]
    $self._page[^hash::create[$hPage]]
#end @SET_page[]



##############################################################################
@SET_data[mData]
    $self._original_data[$mData]

    ^switch[$self._original_data.CLASS_NAME]{
        ^case[array]{
            $self._data[^array::create[]]

            ^foreach[$self._original_data;_data_object]{
                ^self._data.add[^ResourceObject::create[$_data_object;$self]]
            }

            ^if($self._include){
                ^self._prepare_included[$self._original_data;$self._include]
            }
        }

        ^case[DEFAULT]{
            $self._data[^ResourceObject::create[$self._original_data;$self]]

            ^if($self._include){
                ^self._prepare_included[^array::create[
                    $.0[$self._original_data]
                ];$self._include]
            }
        }
    }
#end @SET_data[]



##############################################################################
@add_error[oError]
    ^self._errors.add[$oError]
#end @add_error[]



##############################################################################
@add_link[sKey;oLink]
    $self._links.[$sKey][$oLink]
#end @add_links[]



##############################################################################
@add_meta[sKey;mValue]
    $self._meta.[$sKey][$mValue]
#end @add_meta[]



##############################################################################
@GET_data[]
    $result[
        $.data[$self._data]
        ^if($self._errors){
            $.errors[$self._errors]
        }
        ^if($self._meta){
            $.meta[$self._meta]
        }
        ^if($self._jsonapi){
            $.jsonapi[$self._jsonapi]
        }
        ^if($self._links){
            $.links[$self._links]
        }
        ^if($self._included){
            $.included[$self._included]
        }
    ]
#end @GET_data[]



##############################################################################
@_prepare_included[aModels;hAssociations]
    ^foreach[$aModels;oModel]{
        ^hAssociations.foreach[association;child_associations]{
            $association_object[$oModel.[$association]]
            $association_values[^array::create[]]

            ^switch[$association_object.CLASS_NAME]{
                ^case[BelongsToAssociation;HasOneAssociation]{
                    $object[$association_object.object]
                    ^if($object is ActiveRelation){
                        ^continue[]
                    }

                    ^association_values.add[^ResourceObject::create[$object][
                        $._with_attributes(true)
                        $._with_relationships(false)
                        $._fields[$self._fields]
                    ]]
                }

                ^case[HasManyAssociation;HasAndBelongsToManyAssociation]{
                    ^foreach[$association_object;object]{
                        ^association_values.add[^ResourceObject::create[$object][
                            $._with_attributes(true)
                            $._with_relationships(false)
                            $._fields[$self._fields]
                        ]]
                    }
                }
            }

            ^self._included.join[$association_values]

            ^if($child_associations && $child_associations is hash){
                ^self._prepare_included[$association_values;$child_associations]
            }
        }
    }
#end @_prepare_included[]



##############################################################################
@static:json[key;collection;options]
    $result[^json:string[$collection.data][$options]]
#end @static:json[]
