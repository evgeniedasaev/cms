##############################################################################
#
##############################################################################

@CLASS
JumpFilter

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[object_id][					^rem{ *** привязка к object *** }
		$.type[int]
	]
	^field[category_id][				^rem{ *** привязка к категории для построения ссылки *** }
		$.type[int]
	]
	^field[dt_create][
		$.type[date]
	]
	^field[dt_update][
		$.type[date]
	]

	^field_accessor[property_values]
	
	^belongs_to[object]
	^belongs_to[category][
		$.class_name[Object]
		$.foreign_key[category_id]
	]
	^has_and_belongs_to_many[properties][
		$.class_name[GoodsPropertyPosibleValue]
		$.join_table[jump_filter_to_goods_property_posible_value]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	$self.dt_create[^date::now[]]
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]
#end @before_save[]



##############################################################################
@after_save[]
	^BASE:after_save[]

	^self.save_property_values[]
#end @after_save[]



##############################################################################
@save_property_values[]
	^if($self.property_values){
		$goods_property_posible_values[^array::create[]]
		^foreach[$self.property_values;values]{
			^foreach[$values;value]{
				^goods_property_posible_values.add[^GoodsPropertyPosibleValue:find($value)]
			}
		}

		$self.properties[$goods_property_posible_values]
	}
#end @save_property_values[]