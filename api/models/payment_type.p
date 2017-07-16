##############################################################################
#
##############################################################################

@CLASS
PaymentType

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[name][
		$.type[string]
	]
	^field[commission][
		$.type[double]
	]
	^field[code][
		$.type[string]
	]
	^field[description][
		$.type[string]
	]
	^field[is_paid_via_internet][
		$.type[bool]
	]
	^field[is_published][
		$.type[bool]
	]
	^field[sort_order][
		$.type[int]
	]

	^rem{ *** валидаторы *** }
	^validates_presence_of[name]

	^rem{ *** связи *** }
	^has_and_belongs_to_many[delivery_types][
		$.class_name[DeliveryType]
		$.join_table[payment_type_to_delivery_type]
	]

	^scope[sorted][
		$.order[sort_order ASC]
	]
#end @auto[]



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
@before_validate[]
	^BASE:before_validate[]

#end @before_validate[]


##############################################################################
@after_destroy[]
	^BASE:after_destroy[]

	^self.delivery_types.clear[]
#end @after_destroy[]
