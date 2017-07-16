##############################################################################
#	
##############################################################################

@CLASS
GoodsSerie

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[brand_id][
		$.type[int]
	]
	^rem{*** префикс типа ***}
	^field[type_prefix][
		$.type[string]
	]
	^field[name][
		$.type[string]
	]
	^field[permalink][
		$.type[string]
	]
	^rem{*** минимальная цена серии в базовой валюте ***}
	^field[min_price][
		$.type[double]
	]
	^rem{*** максимальная цена серии в базовой валюте ***}
	^field[max_price][
		$.type[double]
	]
	^rem{*** краткое описание товара ***}
	^field[description][
		$.type[string]
	]
	^rem{*** полное описание товара ***}
	^field[body][
		$.type[string]
	]
	^field[sort_order][
		$.type[int]
	]
	^field[is_published][
		$.type[bool]
	]
	^field[dt_create][
		$.type[date]
	]
	^field[dt_update][
		$.type[date]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[permalink][
		$.on[update]
	]
	^validates_uniqueness_of[permalink][
		$.scope[brand_id]
	]
	^validates_presence_of[name]
	^validates_presence_of[brand_id]

	^rem{*** ассоциации ***}
	^belongs_to[brand]
	^has_and_belongs_to_many[goods][
		$.class_name[Goods]
		$.join_table[goods_serie_to_goods]
	]
	^has_many[images][
		$.class_name[GoodsSerieImage]

		$.dependent[destroy]
	]
	^has_one[main_image][
		$.class_name[GoodsSerieImage]
		$.condition[is_main = 1]
	]
	^has_many[images_to_goods][
		$.class_name[GoodsSerieImageToGoods]

		$.dependent[destroy]
	]
	^has_many[serie_to_goods][
		$.class_name[GoodsSerieToGoods]

		$.dependent[destroy]
	]
	^has_many[property_values][
		$.class_name[GoodsSeriePropertyValue]

		$.dependent[destroy]
	]
	^has_many[properties][
		$.association[property]
		$.through[property_values]
	]
	^has_many[posible_values][
		$.association[posible_value]
		$.through[property_values]
	]
	
	^rem{ *** scopes *** }
	^scope[published][
		$.condition[goods_serie.is_published = 1]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.dt_create){
		$self.dt_create[^date::now[]]
	}

	^if(!def $self.permalink){
		^rem{ *** генерируем permalink путем транслита названия и удаления запрещенных символов *** }
		$self.permalink[^Urlify:urlify[$self.name]]
	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]
#end @before_save[]



##############################################################################
@GET_prefix[]
	$result[^if(def $self.type_prefix){$self.type_prefix}{Коллекция}]
#end @GET_prefix[]



##############################################################################
@GET_full_name[]
	$result[$self.prefix ^if($self.brand){$self.brand.name }${self.name}]
#end @GET_full_name[]



##############################################################################
@GET_text_for_catalog[]
	$result[${self.description}{{catalog}}${self.body}]
#end @GET_text_for_catalog[]



##############################################################################
@format_seo_name[sSeoName]
	$result[$sSeoName]

	^rem{*** если словоформа не подобралась - используем значение по-умолчанию ***}
	^if(!def $result){
		$result[$self.name]
	}
#end @format_seo_name[]

