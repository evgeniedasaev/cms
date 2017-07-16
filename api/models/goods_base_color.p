##############################################################################
#
##############################################################################

@CLASS
GoodsBaseColor

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^field[name][
		$.type[string]
	]
	^field[name_ru][
		$.type[string]
	]
	^field[permalink][
		$.type[string]
	]
	^field[hex_color][
		$.type[string]
	]
	^field[file_file_name][
		$.type[string]
	]
	^field[sort_order][
		$.type[int]
	]
	^field[is_published][
		$.type[bool]
	]

	^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }
	^validates_presence_of[name]
	^validates_uniqueness_of[permalink]
	^validates_file_of[file]
	^validates_file_of[image]
	^validates_image_of[image]

	^rem{ *** ассоциации *** }
	^has_and_belongs_to_many[childs][
		$.class_name[GoodsColor]
		$.join_table[goods_base_color_to_goods_color]
	]
	^has_and_belongs_to_many[goods][
		$.class_name[Goods]
		$.join_table[goods_base_color_to_goods]
	]
	^has_many[to_goods_color][
		$.class_name[GoodsBaseColorToGoodsColor]

		$.dependent[destroy]
	]
	^has_many[to_goods][
		$.class_name[GoodsBaseColorToGoods]

		$.dependent[destroy]
	]

	^has_attached_file[file]
	^has_attached_image[image][
		$.field[file]

		$.S[
			$.0[
				$.action[crop]

				$.width[80]
				$.height[80]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.xS[
			$.0[
				$.action[crop]

				$.width[15]
				$.height[15]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.thumb[
			$.0[
				$.action[resize]

				$.width[15]
				$.height[10]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
	]

	^rem{ *** скоупы *** }
	^scope[sorted][
		$.order[goods_base_color.sort_order ASC]
	]
	^scope[published][
		$.condition[goods_base_color.is_published = 1]
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

	^if(!def $self.permalink){
		$self.permalink[^Translit::translit_string[^self.title.lower[]]]
	}
#end @before_save[]



##############################################################################
@GET_title[]
	$result[^if(def $self.name_ru){$self.name_ru}{$self.name}]
#end @GET_title[]name
