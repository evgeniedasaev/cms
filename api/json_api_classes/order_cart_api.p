##############################################################################
#
##############################################################################

@CLASS
OrderCartApi

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
	$result[^OrderCart:where[]]
#end @define_resource[]



##############################################################################
@create_item[]
	$attributes[$self._api_params.data.attributes]

	$order[^Order:find_by_id(^attributes.order_id.int(0))]
	^if(!$order){
		^self._collection.add_error[^ErrorObject::create[
            $.status[404]
            $.title[record_not_found]
            $.details[Order with id ^attributes.order_id.int(0) not found in JsonApi::create_item]
        ]]
	}

	$goods[^Goods:find_by_id(^attributes.goods_id.int(0))]
	^if(!$goods){
		^self._collection.add_error[^ErrorObject::create[
            $.status[404]
            $.title[record_not_found]
            $.details[Goods with id ^attributes.goods_id.int(0) not found in JsonApi::create_item]
        ]]
	}

	$variation[]	
	^if($goods.parent_id){
		$variation[$goods]
		$goods[$variation.parent]
	}
	
    
	$item[^OrderCart:first(0)[
		$.condition[order_id = ^order.id.int(0) AND goods_id = ^goods.id.int(0) AND goods_variation_id = ^variation.id.int(0)]
	]]	
	^if(!$item){
		$item[^OrderCart::create[]]
		
		$item.order[$order]
		$item.goods[$goods]
		$item.goods_variation_id($variation.id)
		$item.amount(^self._api_params.data.amount.int(1))
	}{
		$item.amount($item.amount + ^self._api_params.data.amount.int(1))
	}

	^rem{ *** добавляем запись в заказ и уведичиваем на 1 в случае, если такой товар там есть *** }
	^if(^item.save[]){
		$self._collection.data[$item]
	}{
        ^foreach[^item.errors.array[];error]{
            ^self._collection.add_error[^ErrorObject::create[
                $.status[409]
                $.title[$error.code]
                $.details[$oItem.CLASS_NAME with id ^oItem.id.int(0): $error.msg]
            ]]
        }
	}  
    
    $result[$self._collection]
#end @create_item[]