##############################################################################
#
##############################################################################

@CLASS
DeliveryType

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	$self.TYPE[
		$.0[
			$.id[0]
			$.name[Без адреса доставки]
		]
		$.1[
			$.id[1]
			$.name[С адресом доставки]
		]
	]

	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[type_id][
		$.type[int]
	]
	^field[name][
		$.type[string]
	]
	^field[description][
		$.type[string]
	]
	^field[distance_comment][
		$.type[string]
	]
	^field[price_cur][
		$.type[double]
	]
	^field[price_distance_cur][
		$.type[double]
	]
	^field[price_cur_id][
		$.type[int]
	]
	^field[price][
		$.type[double]
	]
	^field[is_published][
		$.type[bool]
	]
	^field[sort_order][
		$.type[int]
	]

	^rem{ *** ассесоры *** }
	^field_accessor[payment_types_list]

	^rem{ *** валидаторы *** }
	^validates_presence_of[name]

	^rem{ *** связи *** }
	^has_many[orders][
		$.class_name[Order]
	]
	^has_many[available_deliveries][
		$.class_name[AvailableDeliveries]
	]
	^has_and_belongs_to_many[payment_types][
		$.class_name[PaymentType]
		$.join_table[payment_type_to_delivery_type]
		$.order[sort_order]
	]

	^scope[sorted][
		$.order[sort_order ASC]
	]
	^scope[published][
		$.condition[is_published = 1]
	]
#end @auto[]



##############################################################################
@GET_price_currency[]
	$result[$Currency:all.[$self.price_cur_id]]
#end @GET_price_currency[]



##############################################################################
@GET_price_distance[]
	$result($self.price_distance_cur * $Currency:all.[$self.price_cur_id].course)
#end @GET_price_distance[]



##############################################################################
@GET_is_timed[]
	$result(^self.code.left(6) eq "timed_")
#end @GET_is_timed[]



##############################################################################
@GET_is_lift[]
	$result(^self.code.match[lift])
#end @GET_is_lift[]



##############################################################################
@GET_is_inside[]
	$result($self.price_distance_cur == 0)
#end @GET_is_inside[]



##############################################################################
@GET_is_address_required[]
	$result($self.type_id == $self.TYPE.1.id)
#end @GET_is_address_required[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	^rem{ *** обновляем цену в базовой валюте *** }
	$self.price($self.price_cur * $Currency:all.[$self.price_cur_id].course)

	^rem{ *** если новый *** }
	^if($self.is_new){
		^rem{ *** определяем sort_order *** }
		$self.sort_order(^oSql.int{SELECT MAX(sort_order) FROM $self.table_name}[ $.default(0) ] + 1)
	}
#end @before_save[]



##############################################################################
@after_destroy[]
	^BASE:after_destroy[]

	^self.payment_types.clear[]
#end @after_destroy[]
