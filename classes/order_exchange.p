##############################################################################
#	
##############################################################################

@CLASS
OrderExchange

@OPTIONS
locals



##############################################################################
@import[order]
$result[$order.id
^order.dt_create.sql-string[]
$order.status.name
$order.delivery.name
$order.delivery_price
$order.customer_title
^if($order.city){$order.city.name}
^rem{ *** метро *** }
$order.address
$order.phone
^if($order.dt_delivery){^order.dt_delivery.sql-string[]}
^if(def $order.dt_delivery_time_from){$order.dt_delivery_time_from} - ^if(def $order.dt_delivery_time_to){$order.dt_delivery_time_to}
^rem{ *** как добраться *** }
$order.comment
$order.payment.name
^rem{ *** купон *** }
^rem{ *** купон ПР *** }
^rem{ *** купон сумма *** }
$order.user.name
^rem{ *** пароль *** }
$order.auser.title
^eval($order.cart)
^foreach[$order.cart;item]{$item.goods.code^;$item.name^;^;$item.qnt^;$item.total^;$item.price_discount^;0^rem{ *** % скидки *** }^;$item.price_discount_type_id}[^#0A]
]
#end @import[]



##############################################################################
@parse[text]
	$result[^hash::create[
		$.cart[^array::create[]]
	]]
	
	$parsed[^text.split[^#0A;lh]]
	
	$result.id[$parsed.0]
	$result.status[$parsed.1]
	$result.delivery_price[$parsed.2]
	$result.item_count[$parsed.3]
	
	^for[i](4;4 + $result.item_count - 1){
		$item[^parsed.[$i].split[^;][lh]]
		
		^result.cart.add[
			$.code[$item.0]
			$.name[$item.1]
			$.qnt[$item.2]
			$.total_price[$item.3]
			$.discount_price[$item.4]											^rem{ *** скидку на 1 товар или общую? *** }
		]
	}
#end @parse[]
