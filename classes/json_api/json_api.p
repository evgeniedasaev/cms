##############################################################################
#
##############################################################################

@CLASS
JsonApi

@USE
json_api/helpers.p
json_api/resource_object.p
json_api/link_object.p
json_api/error_object.p
json_api/collection.p

@OPTIONS
locals



##############################################################################
@create[hParams;sVersion]
    $self._api_params[^prepare_params[$hParams]]
    $self._api_params_raw[^hash::create[$hParams]]

    $self._version[$sVersion]

    ^rem{*** определяем пустую коллекцию ***}
    ^self.define_collection[]

    $self._resource[^self.define_resource[]]  

    ^if(def $self._resource){
        $self._model[$self._resource.MAPPER.CLASS_NAME]
        $self._table_name[^string_transform[$self._model;classname_to_filename]]
        
        ^rem{*** накладываем параметры из запроса ***}
        ^if($self._api_params.filter){
            ^self.define_filter[]
        }

        ^if($self._api_params.sort){
            ^self.define_sort[]
        }

        ^if($self._api_params.page){
            ^self.define_paginator[]
        }     
	
	    ^rem{*** определяем сопутствующие данные ***}
        ^if($self._api_params.include){
	        ^self.define_include[]
        }
    }
#end @create[]



##############################################################################
@define_collection[]
	$self._collection[^Collection::create[
		$.version[$self._version]
		
        $.with_attributes(^self.with_attributes.bool(true))
		$.with_relationships(^self.with_relationships.bool(true))
	]]
    
    ^if($self._api_params.field){
        $self._collection.field[$self._api_params.field]
    }
#end @define_collection[]



##############################################################################
@define_resource[]
    ^self._collection.add_error[^ErrorObject::create[
        $.status[403]
        $.title[resource_not_defined]
        $.details[Method JsonApi::define_resource should be redefined in API class]
    ]]
#end @define_resource[]



##############################################################################
@define_filter[]
    ^self._api_params.filter.foreach[field;values]{
        ^switch[$values.CLASS_NAME]{
            ^case[array]{
                ^if($values){
                    $self._resource[^self._resource.where[^print_field[$field;$self._table_name] IN (^foreach[$values;value]{"${value}"}[,])]]
                }
            }
            ^case[string]{
                $self._resource[^self._resource.where[^print_field[$field;$self._table_name] = "$values"]]
            }
        }
    }
#end @define_filter[]



##############################################################################
@define_sort[]	
    ^foreach[$self._api_params.sort;sort]{
        $self._resource[^self._resource.sort[^print_field[$sort.field;$self._table_name];$sort.direction]]
    }
#end @define_sort[]



##############################################################################
@define_paginator[]
    $self._limit(100)
    $self._page(1)

    $self._limit(^self._api_params.page.size.int($self._limit))
    $self._page(^self._api_params.page.number.int($self._page))
    
    $self._collection.page[$self._page]
    
    $self._resource[^self._resource.limit($self._limit)]
    $self._resource[^self._resource.offset(($self._page - 1) * $self._limit)]		
    
    $self._objects_amount(^self._resource.count[])
    $self._pages_amount(^math:ceiling($self._objects_amount/$self._limit))

    ^self._collection.add_meta[page_num;$self._page]
    ^self._collection.add_meta[page_amount;$self._pages_amount]
    ^self._collection.add_meta[total_amount;$self._objects_amount]
    
    $params_clone[^hash::create[$self._api_params_raw]]
    ^if(!def $params_clone.page){
        $params_clone.page[^hash::create[]]
    }
    
    $params_clone.page.number(1)
    ^self._collection.add_link[first;^LinkObject::create[$self._table_name;fetch_list;$params_clone]]
    
    $params_clone.page.number($self._pages_amount)
    ^self._collection.add_link[last;^LinkObject::create[$self._table_name;fetch_list;$params_clone]]

    ^if(^eval($self._page - 1) > 0){
        $params_clone.page.number(^eval($self._page - 1))
        ^self._collection.add_link[prev;^LinkObject::create[$self._table_name;fetch_list;$params_clone]]
    }

    ^if(^eval($self._page + 1) <= $pages_amount){
        $params_clone.page.number(^eval($self._page + 1))
        ^self._collection.add_link[next;^LinkObject::create[$self._table_name;fetch_list;$params_clone]]
    }   
#end @define_paginator[]



##############################################################################
@define_include[]
    $self._resource[^self._resource.include[$self._api_params.include]]
    
    $self._collection.include[$self._api_params.include]
#end @define_include[]



##############################################################################
@fetch_list[]
    $self._collection.data[$self._resource.records]
    
    $result[$self._collection]
#end @fetch_list[]



##############################################################################
@fetch_item[]
    $id(^self._api_params.id.int(0))
    $item[^self._resource.MAPPER.find_by_id($id)]
    
    ^if($item){
        $self._collection.data[$item]
    }{
        ^self._collection.add_error[^ErrorObject::create[
            $.status[404]
            $.title[record_not_found]
            $.details[$self._resource.MAPPER.CLASS_NAME with id ^id.int(0) not found in JsonApi::fetch_item]
        ]]
    }
   
    $result[$self._collection]
#end @fetch_item[]



##############################################################################
@fetch_relationships[]
    $id(^self._api_params.id.int(0))
    $item[^self._resource.MAPPER.find_by_id($id)]
    
    ^if($item){
        $relationship[$item.[$self._api_params.relationship]]

        ^if(def $relationship){
            ^switch[$relationship.CLASS_NAME]{
                ^case[BelongsToAssociation;HasOneAssociation]{
                    $self._collection.data[$NULL]

                    ^if(!$relationship.object){
                        $self._collection.data[$relationship.object]
                    }
                }
            
                ^case[HasManyAssociation;HasAndBelongsToManyAssociation]{
                    $self._collection.data[$relationship.list.records]
                }
            }
        }{
            ^self._collection.add_error[^ErrorObject::create[
                $.status[404]
                $.title[relationship_not_found]
                $.details[Relationship "$self._api_params.relationship" of $self._resource.MAPPER.CLASS_NAME with id ^id.int(0) not found in JsonApi::fetch_relationships]
            ]]
        }
    }{
        ^self._collection.add_error[^ErrorObject::create[
            $.status[404]
            $.title[record_not_found]
            $.details[$self._resource.MAPPER.CLASS_NAME with id ^id.int(0) not found in JsonApi::fetch_relationships]
        ]]
    } 
    
    $result[$self._collection]
#end @fetch_relationships[]



##############################################################################
@create_item[]
    $item[^process{^^${self._model}::create[]}]

    $result[^self._update_item[$item]]
#end @create_item[]



##############################################################################
@update_item[]
    $id(^self._api_params.data.id.int(0))
    $item[^self._resource.MAPPER.find_by_id($id)]

    ^if($item){
        $result[^self._update_item[$item]]
    }{
        ^self._collection.add_error[^ErrorObject::create[
            $.status[404]
            $.title[record_not_found]
            $.details[$self._resource.MAPPER.CLASS_NAME with id ^id.int(0) not found in JsonApi::update_item]
        ]]
        
        $result[$self._collection]
    }   
#end @update_item[]



##############################################################################
@_update_item[oItem]  
    ^update_item_with_attributes[$oItem;$self._api_params.data]
    
    ^if(^oItem.save[]){
        $self._collection.data[$oItem]
    }{
        ^foreach[^oItem.errors.array[];error]{
            ^self._collection.add_error[^ErrorObject::create[
                $.status[409]
                $.title[$error.code]
                $.details[$oItem.CLASS_NAME with id ^oItem.id.int(0): $error.msg]
            ]]
        }
    }    
    
    $result[$self._collection]
#end @_update_item[]



##############################################################################
@delete_item[]
    $id(^self._api_params.data.id.int(0))
    $item[^self._resource.MAPPER.find_by_id($id)]
    
    ^if($item){
        $res(^item.destroy[])
        
        $self._collection.data[$NULL]
    }{
        ^self._collection.add_error[^ErrorObject::create[
            $.status[404]
            $.title[record_not_found]
            $.details[$self._resource.MAPPER.CLASS_NAME with id ^id.int(0) not found in JsonApi::delete_item]
        ]]
    }
   
    $result[$self._collection]
#end @delete_item[]



##############################################################################
@static:print_json[hData]
    $result[^json:string[$hData][        
        $.void[null]
        $.array[$array:json]
        $.Collection[$Collection:json]            
        $.ResourceObject[$ResourceObject:json]    
        $.LinkObject[$LinkObject:json]
        $.ErrorObject[$ErrorObject:json]
    ]]
#end @print_json[]
