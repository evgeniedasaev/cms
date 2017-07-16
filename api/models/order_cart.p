##############################################################################
#
##############################################################################

@CLASS
OrderCart

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[order_id][
		$.type[int]
	]
	^field[goods_id][
		$.type[int]
	]
	^field[goods_variation_id][
		$.type[int]
	]
	^field[code][
		$.type[string]
	]
	^field[name][
		$.type[string]
	]

	^rem{ *** себестоимость *** }
	^field[cost_cur][
		$.type[double]
	]
	^field[cost_cur_id][
		$.type[int]
	]
	^field[cost][
		$.type[double]
	]

	^rem{ *** продажная цена *** }
	^field[price_cur][
		$.type[double]
	]
	^field[price_cur_id][
		$.type[int]
	]
	^field[price][
		$.type[double]
	]

	^rem{ *** продажная цена с учетом скидки *** }
	^field[price_discount][
		$.type[double]
	]
	^field[price_discount_type_id][
		$.type[double]
	]

	^field[amount][
		$.type[int]
	]
	^field[reserve][
		$.type[int]
	]
	
	^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }
	^validates_presence_of[order_id]
	^validates_presence_of[goods_id]
	^validates_presence_of[name]
# 	^validates_presence_of[price_cur_id]

	^rem{ *** связи *** }
	^belongs_to[order][
		$.touch[recalculate_total]
	]
	^belongs_to[goods]
#end @auto[]



##############################################################################
@SET_goods[oGoods]
	$self.goods_id($oGoods.id)
	$self.code[$oGoods.code]
	$self.name[$oGoods.full_title]
	$self.cost_cur[$oGoods.cost_cur]
	$self.cost_cur_id($oGoods.cost_cur_id)
	$self.price_cur[$oGoods.price_cur]
	$self.price_cur_id($oGoods.price_cur_id)
	
	^if($oGoods.price_old_cur){
		$self.price_cur[$oGoods.price_old_cur]
		$self.price_discount((1 - $oGoods.price_cur/$oGoods.price_old_cur) * 100)
	}
#end @SET_goods[]



##############################################################################
@GET_base_goods[]
	$result[$self.goods.base_goods]
#end @GET_base_goods[]



##############################################################################
@GET_cost_currency[]
	$result[$Currency:all.[$self.cost_cur_id]]
#end @GET_price_currency[]



##############################################################################
#	Себестоимость товара за штуку
##############################################################################
@GET_cost[]
	$result($self.cost_cur * ^self.cost_currency.rate.int(1))
#end @GET_price[]



##############################################################################
@GET_price_currency[]
	$result[$Currency:all.[$self.price_cur_id]]
#end @GET_price_currency[]



##############################################################################
#	Цена товара за штуку
##############################################################################
@GET_price[]
	$result($self.price_cur * ^self.price_currency.rate.int(1))
#end @GET_price[]



##############################################################################
#	Экономия
##############################################################################
@GET_saving[]
	$result(0)

	^if($self.price_discount){
		^switch[$self.price_discount_type_id]{
			^case(0){
				$result($self.price * $self.price_discount / 100)
			}		
			^case[DEFAULT]{
				$result($self.price_discount * $Currency:all.[$self.price_discount_type_id].rate)
			}
		}
	}	
#end @GET_saving[]



##############################################################################
#	Цена со скидкой на товар
##############################################################################
@GET_price_with_saving[]
	$result($self.price - $self.saving)
#end @GET_price_with_saving[]



##############################################################################
#	Цена со скидками
##############################################################################
@GET_price_with_discount[]
	$result($self.price_with_saving)
	
 	^if($self.order.discount && !$self.price_discount){
		^switch[$self.order.discount_type_id]{
			^case(0){
				^result.mul(1 - $self.order.discount / 100)
			}		
			^case[DEFAULT]{
				^result.dec($self.order.discount * $Currency:all.[$self.order.discount_type_id].rate)
			}
		}
	}

	$result(^math:round($result))
#end @GET_price_with_discount[]



##############################################################################
#	Маржа
##############################################################################
@GET_margin[]
	$cost($self.cost)

	^if($cost){
		$result($self.amount * ($self.price_with_discount - $cost))
	}{
		$result(0)
	}
#end @GET_total[]



##############################################################################
@GET_qnt[]
	$result[$self.amount]
#end @GET_qnt[]



##############################################################################
#	Итого со скидками
##############################################################################
@GET_total[]
	$result($self.amount * $self.price_with_discount)
#end @GET_total[]



##############################################################################
#	Итого со скидкйо на конкретный товар
##############################################################################
@GET_total_with_saving[]
	$result($self.amount * $self.price_with_saving)
#end @GET_total_with_saving[]



##############################################################################
#	Итого без скидки
##############################################################################
@GET_total_without_discount[]
	$result($self.amount * $self.price)
#end @GET_total_without_discount[]



##############################################################################
#	Доступно для заказа без учета текущего резерва
##############################################################################
@GET_goods_availible_for_order[]
	$result($self.goods.availible_for_order - $self.reserve)
#end @GET_goods_availible_for_order[]



##############################################################################
@GET_goods_reserve[]
	$result($self.goods.reserved + $self.reserve)
#end @GET_goods_reserve[]



##############################################################################
@undo_reserve[bSkipSave]
	^rem{ *** если заказ выполнен или отменен => снимаем резерв автоматически *** }
	^if($self.order.status.base_status_id == $OrderStatus:BASE.done.id || $self.order.status.base_status_id == $OrderStatus:BASE.cancel.id){
		$self.reserve[0]
	}

	^if(!$bSkipSave){
		^if(!^self.save[]){
			^throw_inspect[^self.errors.array[]]
		}
	}
#end @undo_reserve[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	^self.undo_reserve(true)
#end @before_save[]



##############################################################################
@after_save[]
	^BASE:after_save[]

	^if($self.reserve != $self.reserve_was && $self.goods){
		^rem{ *** резервируем товар *** }
		^if(!^self.goods.update_attributes[
			$.reserved($self.goods.reserved - ^self.reserve_was.int(0) + ^self.reserve.int(0))
		]){
			^throw_inspect[^self.goods.errors.array[]]
		}
#		$r[^Goods:update_all[
#			$._reserved[reserved - ^self.reserve_was.int(0) + ^self.reserve.int(0)]
#		][
#			$.condition[goods_id = $self.goods_id]
#		]]
	}
#end @after_save[]



##############################################################################
@after_destroy[]
	^BASE:after_destroy[]
	
	^if($self.is_changed){
		$data[$self.attributes_was]
	}{
		$data[$self.attributes]
	}
	
	^rem{ *** освобождаем резерв при удалении *** }
	^if($self.goods && !^self.goods.update_attributes[
		$.reserved($self.goods.reserved - ^self.reserve.int(0))
	]){
		^throw_inspect[^self.goods.errors.array[]]
	}
#	$r[^Goods:update_all[
#		$._reserved[reserved - ^data.int(0)]
#	][
#		$.condition[goods_id = $self.goods_id]
#	]]
#end @after_destroy[]



##############################################################################
@prepare_for_api[]
    $result[^hash::create[$self.attributes]]

	$result.goods_in_stock[$self.goods.in_stock]
	$result.goods_availible_for_order[$self.goods_availible_for_order]
	$result.goods_reserve[$self.goods_reserve]

	$result.total[$self.total]
	$result.margin[$self.margin]
#end @prepare_for_api[]