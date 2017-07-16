##############################################################################
#
##############################################################################

@CLASS
GoodsApi

@USE
json_api/json_api.p

@OPTIONS
locals

@BASE
JsonApi



##############################################################################
# Определяем resource
##############################################################################
@define_resource[]
	$result[^Goods:where[goods.parent_id IS NULL]]
#end @define_resource[]



##############################################################################
# Перекрываем фильтр для заказов
##############################################################################
@define_filter[]   
    ^if(def $self._api_params.filter.text || def $self._api_params.filter.code){
		^rem{ *** также осуществляем поиск по id & артикулам вариантов *** }
		$self._resource[^self._resource.join[
			$.goods_variantions[
				$.name[variations]
				$.type[left]
			]
		]]
	}
    
    ^if(def $self._api_params.filter.text){
		$self._resource[^self._resource.where[(
			goods.goods_id LIKE '%$self._api_params.filter.text%' OR
			goods.model LIKE '%$self._api_params.filter.text%' OR
			goods.name LIKE '%$self._api_params.filter.text%' OR
            goods_variantions.goods_id LIKE '%$self._api_params.filter.text%'
		)]]
	}

	^if(def $self._api_params.filter.code){
		$self._resource[^self._resource.where[(
			goods.code LIKE '%$self._api_params.filter.code%' OR
			goods_variantions.code LIKE '%$self._api_params.filter.code%'
		)]]
	}

	^if($self._api_params.filter.type_id){
		$self._resource[^self._resource.where[goods.goods_type_id IN (^foreach[$self._api_params.filter.type_id;type_id]{$type_id}[,])]]
	}

	^if($self._api_params.filter.brand_id){
		$self._resource[^self._resource.where[goods.brand_id IN (^foreach[$self._api_params.filter.brand_id;brand_id]{$brand_id}[,])]]
	}

	^if($self._api_params.filter.status_id){
		$self._resource[^self._resource.where[order.status_id IN (^foreach[$self._api_params.filter.status_id;status_id]{$status_id}[,])]]
	}
    
    ^if($self._api_params.filter.category_id){
        $categories[^Object:find[$self._api_params.filter.category_id]]
    
        ^if($categories){
            $self._resource[^self._resource.join[categories]]
            $self._resource[^self._resource.where[categories.object_id IN (^foreach[$categories;category]{^foreach[$category.child_tree_ids;id]{$id}[,]})]]
        }{
            $self._resource[^self._resource.where[goods.category_id = 0]]
        }
    }
    
    ^if(^self._api_params.filter.published.0.int(-1) >= 0){
		$self._resource[^self._resource.where[goods.is_published = $self._api_params.filter.published.0]]
	}
	
	^switch(^self._api_params.filter.availible.0.int(-1)){
		^case(2){
			$self._resource[^self._resource.where[goods.in_stock < goods.reserved]]
		}
		^case(1){
			$self._resource[^self._resource.where[goods.in_stock > 0]]
		}
		^case(0){
			$self._resource[^self._resource.where[goods.in_stock = 0]]
		}
	}

	^if(^self._api_params.filter.is_complect.0.int(-1) >= 0){
		$self._resource[^self._resource.where[goods.is_complect = $self._api_params.filter.is_complect.0]]
	}
#end @define_filter[]
