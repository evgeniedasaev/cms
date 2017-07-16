##############################################################################
#
##############################################################################

@CLASS
OrderStatus

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	$self.BASE[^enum::create[
		$.new[
			$.id[0]
			$.name[Новый заказ]
		]
		$.confirm[
			$.id[1]
			$.name[Заказ подтвержден]
		]
		$.done[
			$.id[2]
			$.name[Заказ выполнен]
		]
		$.cancel[
			$.id[3]
			$.name[Заказ отменен]
		]
	]]

	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[base_status_id][
		$.type[int]
	]
	^field[name][
		$.type[string]
	]
	^field[color][
		$.type[string]
	]
	^field[sort_order][
		$.type[int]
	]

	^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }
	^validates_presence_of[name]
	^validates_presence_of[base_status_id]

	^scope[sorted][
		$.order[sort_order ASC]
	]
#end @auto[]



##############################################################################
@GET_NEW[]
	$result[^self.first(1)[
		$.condition[base_status_id = $self.BASE.new.id]
		$.order[sort_order]
	]]
#end @GET_NEW[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	^rem{ *** если новый *** }
	^if($self.is_new){
		^rem{ *** определяем sort_order *** }
		$self.sort_order(^oSql.int{SELECT MAX(sort_order) FROM $self.table_name}[ $.default(0) ] + 1)
	}
#end @before_save[]



##############################################################################
@prepare_for_api[]
    $result[^hash::create[$self.attributes]]

    $base_statuses[^OrderStatus:BASE.hash[id]]
    $base_status[$base_statuses.[$self.base_status_id]]

    ^if($base_status){
        $result.base_status[$base_status.name]     
    }
#end @prepare_for_api[]
