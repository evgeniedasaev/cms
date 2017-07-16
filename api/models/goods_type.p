##############################################################################
#
##############################################################################

@CLASS
GoodsType

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[category_id][
		$.type[int]
	]
	^field[external_name][
		$.type[string]
	]	
	^field[name][
		$.type[string]
	]
	^field[prefix][
		$.type[string]
	]
	^field[permalink][
		$.type[string]
	]
	^field[sort_order][
		$.type[int]
	]
	^field[gender][
		$.type[string]
	]	

	^validates_presence_of[name]
	^validates_uniqueness_of[permalink][
		$.on[update]
	]
	^validates_format_of[permalink][
	    $.width[^^[a-z0-9_\-]+^$]
	    $.modificator[i]
	]

	^belongs_to[category][
		$.class_name[Object]
	]
	^has_many[goods][
		$.dependent[nulled]
	]
	^has_and_belongs_to_many[properties][										^rem{ *** связанные характеристики *** }
		$.class_name[GoodsProperty]
		$.join_table[goods_property_to_goods_type]
		$.order[sort_order]
	]
	^has_and_belongs_to_many[foreground_properties][							^rem{ *** приоритетные характеристики *** }
		$.class_name[GoodsProperty]
		$.join_table[goods_type_to_foreground_goods_property]
	]
	^has_many[seo_text_parts][
		$.class_name[SeoTextPart]
		$.foreign_key[object_id]
		$.condition[object_class = "GoodsType"]
	]

	^rem{ *** scopes *** }
	^scope[sorted][
		$.order[sort_order]
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

	^if(!def $self.permalink){
		^rem{ *** генерируем permalink путем транслита названия и удаления запрещенных символов *** }
		$self.permalink[^Urlify:urlify[$self.name]]
	}
#end @before_save[]




##############################################################################
@format_seo_name[sSeoName]
	$result[$sSeoName]

	^rem{*** если словоформа не подобралась - используем значение по-умолчанию ***}
	^if(!def $result){
		$result[$self.name]
	}
	
	^rem{*** приводим к нижнему регистру ***}
	$result[^result.lower[]]
#end @format_seo_name[]