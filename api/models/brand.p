##############################################################################
#
##############################################################################

@CLASS
Brand

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[country_id][
		$.type[int]
	]
	^field[name][
		$.type[string]
	]
	^field[permalink][
		$.type[string]
	]
	^field[logo_file_name][
		$.type[string]
	]
	^field[body][
		$.type[string]
	]
	^field[web_page][
		$.type[string]
	]
	^field[is_popular][
		$.type[int]
	]
	^field[is_published][
		$.type[int]
	]
	
	^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }
	^validates_presence_of[name]
	^validates_presence_of[permalink][
		$.on[update]
	]
	^validates_uniqueness_of[permalink]
	^validates_format_of[permalink][
	    $.width[^^[a-z0-9_\-]+^$]
	    $.modificator[i]
	]
	^validates_file_of[logo]
	^validates_image_of[logo]

	^rem{ *** связи *** }
	^belongs_to[country][
		$.class_name[GoodsPropertyPosibleValue]
		$.foreign_key[country_id]
	]	
	^has_many[goods][
		$.class_name[Goods]

#		$.dependent[nulled]
	]
	^has_many[series][
		$.class_name[GoodsSerie]
	]
	
	^has_attached_image[logo][
		$.thumb[
			$.0[
				$.action[resize]

				$.width[300]
				$.height[300]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.small[
			$.0[
				$.action[resize]

				$.width[150]
				$.height[150]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
	]
	
	^rem{ *** scopes *** }
	^scope[sorted][
		$.order[name]
	]
	^scope[popular][
		$.condition[is_popular = 1]
	]
#end @auto[]



##############################################################################
@before_save[]
	^BASE:before_save[]
	
	^if(!def $self.permalink){
		^rem{ *** генерируем permalink путем транслита названия и удаления запрещенных символов *** }
		$self.permalink[^Urlify:urlify[$self.name]]
	}
#end @before_save[]



##############################################################################
@GET_web_page[]
	$result[^self.attributes.web_page.match[^^(https?://)?(.*)^$][gi]{$match.2}]
#end @GET_web_page[]



##############################################################################
@GET_first_letter[]
	$result[^self.attributes.name.left(1)]
#end @GET_first_letter[]



##############################################################################
@format_seo_name[sSeoName]
	$result[$sSeoName]

	^rem{*** если словоформа не подобралась - используем значение по-умолчанию ***}
	^if(!def $result){
		$result[$self.name]
	}
#end @format_seo_name[]
