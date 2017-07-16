##############################################################################
#	
##############################################################################

@CLASS
GoodsProperty

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	$self.ENTITY_TYPES[^enum::create[
		$.goods[
			$.id(1)
			$.name[Товара]
			$.code[goods]
			$.controller[goods]
			$.color[green]
		]
		$.series[
			$.id(2)
			$.name[Серии]
			$.code[series]
			$.controller[goods_series]
			$.color[blue]
		]
	]]

	$self.PROPERTY_TYPES[^enum::create[
		$.multiple[
			$.id[1]
			$.name[Множественная характеристика]
		]
		$.single[
			$.id[2]
			$.name[Единственная характеристика]
		]
	]]

	$self.VALUE_TYPES[^enum::create[
		$.int[
			$.id[2]
			$.name[Целое число]
		]
		$.double[
			$.id[3]
			$.name[Число с плавающей точкой]
		]
		$.date[
			$.id[4]
			$.name[Дата и время]
		]
		$.string[
			$.id[5]
			$.name[Строка]
		]
		$.text[
			$.id[6]
			$.name[Текст]
		]
	]]

	^rem{ *** аттрибуты *** }
	^field[entity_type][
		$.type[string]
	]
	^field[property_type_id][
		$.type[int]
	]
	^field[value_type_id][
		$.type[int]
	]
	^field[code][
		$.type[string]
	]
	^field[name][
		$.type[string]
	]
	^field[description][
		$.type[string]
	]
	^field[meta_text][
		$.type[string]
	]
	^field[unit][
		$.type[string]
	]
	^field[sort_order][
		$.type[int]
	]
	^field[is_in_filter][
		$.type[bool]
	]
	^field[show_in_goods][
		$.type[bool]
	]
	^field[show_link_in_goods][
		$.type[bool]
	]

    ^rem{ *** ассесоры *** }

	^rem{ *** ассоциации *** }
	^has_many[posible_values][
		$.class_name[GoodsPropertyPosibleValue]
		$.order[posible_values.sort_order]

		$.dependent[destroy]
	]
	^has_many[values][
		$.class_name[GoodsPropertyValue]
	]
	^has_and_belongs_to_many[categories][
		$.class_name[Object]
		$.join_table[filter_property]
	]

	^rem{ *** валидаторы *** }
	^validates_presence_of[value_type_id]
	^validates_presence_of[code][
		$.on[update]
	]
	^validates_presence_of[name]

#	TODO: goods_type_id OR characteristic_type_id must be defined
#	^validate_with[belongs_to_group_or_goods_type]

	^rem{ *** scopes *** }
	^scope[sorted][
		$.order[sort_order]
	]
	^scope[defaults][
		$.condition[is_in_filter = 1]
	]
	^scope[for_goods][
		$.condition[entity_type = "$self.CLASS.ENTITY_TYPES.goods.code"]
	]
	^scope[for_series][
		$.condition[entity_type = "$self.CLASS.ENTITY_TYPES.series.code"]
	]
	^scope[for_goods_page][
		$.condition[show_in_goods = 1]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.code){
		$self.code[^Urlify:urlify[$self.name]]
	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]
	
	^rem{ *** если новый *** }
	^if($self.is_new || $self.parent_id != $self.parent_id_was){
		^rem{ *** определяем sort_order *** }
		$self.sort_order(^oSql.int{SELECT MAX(sort_order) FROM $self.table_name}[ $.default(0) ] + 1)
	}
#end @before_save[]



##############################################################################
@GET_title[]
	^if(def $self.description){
		$result[$self.description]
	}{
		$result[$self.name]
	}
#end @GET_title[]



##############################################################################
@GET_entity_type_name[]
	$result[$GoodsProperty:ENTITY_TYPES.[$self.entity_type].name]
#end @GET_entity_type_name[]



##############################################################################
@GET_entity_type_color[]
	$result[$GoodsProperty:ENTITY_TYPES.[$self.entity_type].color]
#end @GET_entity_type_color[]



##############################################################################
@GET_entity_type_code[]
	$result[$GoodsProperty:ENTITY_TYPES.[$self.entity_type].code]
#end @GET_entity_type_code[]



##############################################################################
@GET_controller[]
	$result[$GoodsProperty:ENTITY_TYPES.[$self.entity_type].controller]
#end @GET_controller[]



##############################################################################
@GET_value_field[]	
	^switch($self.value_type_id){
		^case(1){
			$result[val_int]
		}
		^case(2){
			$result[val_int]
		}
		^case(3){
			$result[val_double]
		}
		^case(4){
			$result[val_date]
		}
		^case(5){
			$result[val_string]
		}
		^case(6){
			$result[val_text]
		}
	}
#end @GET_value_field[]
