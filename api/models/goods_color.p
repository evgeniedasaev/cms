##############################################################################
#
##############################################################################

@CLASS
GoodsColor

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^field[brand_id][
		$.type[int]
	]
	^field[name][
		$.type[string]
	]
	^field[name_ru][
		$.type[string]
	]
	^field[sort_order][
		$.type[int]
	]
	^field[is_published][
		$.type[bool]
	]
	^field[is_prefix][
		$.type[bool]
	]

	^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }
	^validates_presence_of[name]
	^validates_presence_of[brand_id]

	^rem{ *** ассоциации *** }
	^belongs_to[brand]
	^has_and_belongs_to_many[base_colors][
		$.class_name[GoodsBaseColor]
		$.join_table[goods_base_color_to_goods_color]
	]
	^has_many[values][
		$.class_name[GoodsPropertyValue]
		$.foreign_key[goods_property_posible_value_id]
		$.condition[goods_property_id = $COLOR_PROPERTY_ID]

		$.dependent[destroy]
	]
	^has_many[goods][
		$.through[values]
		$.association[goods]
	]
	^has_many[to_goods_base_color][
		$.class_name[GoodsBaseColorToGoodsColor]

		$.dependent[destroy]
	]
	^has_many[seo_text_parts][
		$.class_name[SeoTextPart]
		$.foreign_key[object_id]
		$.condition[object_class = "GoodsPropertyPosibleValue"]
	]

	^rem{ *** скоупы *** }
	^scope[sorted][
		$.order[sort_order ASC]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	$self.sort_order(^oSql.int{SELECT MAX(sort_order) AS new_sort_order FROM $self.table_name}[ $.default(0) ] + 1)
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]
#end @before_save[]



##############################################################################
#	Используется для вывода цветов на форме привязки хар-к к товарам
#		Цвета должны иметь description, так как для привязки их к товарам они используются, 
#		как property_posible_valuе, у которых нет поля name, а есть description.
##############################################################################
@GET_description[]
	$result[$self.name]
#end @GET_description[]



##############################################################################
@GET_value[]
	$result[$self.name]
#end @GET_value[]



##############################################################################
@format_seo_name[sSeoName]
	$result[$sSeoName]

	^rem{*** если словоформа не подобралась - используем значение по-умолчанию ***}
	^if(!def $result){
		$result[$self.value]
	}
#end @format_seo_name[]
