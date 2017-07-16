##############################################################################
# Класс используется для построения seo-текстов и содержимого meta-тегов
##############################################################################

@CLASS
SeoGenerator



##############################################################################
@create[]
	^rem{*** задаем перечень родов ***}
	$self._genders[
		$.0[femenine]
		$.1[masculine]
		$.2[neuter]
		$.3[multiple]
	]

	^rem{*** и род + падеж по-умолчанию ***}
	$self.DEFAULT_GENDER[masculine]
	$self.DEFAULT_CASE[accusative]

	^rem{*** получаем все seo-шаблоны ***}
	$self._patterns[^SeoTextPattern:all[]]
	$self._patterns[^self._patterns.hash[type]]

	^rem{*** инициируем кэш для словоформ ***}
	$self._seo_text_parts[^hash::create[]]

	^rem{*** инициируем ActiveRelation для построения запроса на словоформы ***}
	^self.__init_seo_parts_query[]
#end @create[]



##############################################################################
# Перечень родов
##############################################################################
@GET_genders[]
	$result[$self._genders]
#end @GET_genders[]



##############################################################################
# Хэш со всеми доступными шаблонами
##############################################################################
@GET_patterns[]
	$result[$self._patterns]
#end @GET_patterns[]



##############################################################################
# Хэш с seo-параметрами
##############################################################################
@GET_seo_params[]
	$result[$self._seo_params]
#end @GET_seo_params[]



##############################################################################
# Метод генерирует seo-контент
##############################################################################
@generate_seo_content[sPatternName;hParams]
	^rem{*** получаем полный шаблон ***}
	$sPattern[^self.__prepare_pattern[$sPatternName]]

	^rem{*** подготавливаем элементы текста ***}
	$hPhraseParts[^self.__prepare_phrase_parts[$sPattern;$hParams]]

	^rem{*** собираем текст из элементов ***}
	$sText[^self.__replace_meta_phrases[$sPattern;$hPhraseParts]]

	^rem{*** форматируем текст ***}
	$result[^CLASS.prepare_catalog_text[$sText]]
#end @generate_seo_text[]



##############################################################################
# Метод генерирует фразы для замены meta-фраз
##############################################################################
@__prepare_phrase_parts[sPattern;hParams]
	$hParams[^hash::create[$hParams]]

	^rem{*** определяем seo-параметры ***}
	^if($hParams.seo_params){
		$text_params[$hParams.seo_params]
	}($self.seo_params){
		$text_params[$self.seo_params]
	}{
		^throw[ErrorSeoGenerator;ErrorSeoGenerator;Seo params is empty. At least types must be set]
	}	

	$types[$text_params.types]

	$gender_and_case[^self.__prepare_gender_and_case[$sPattern;$types]]
	$gender[$gender_and_case.gender]
	$case[$gender_and_case.case]

	^rem{*** обрабатываем все типы ***}
	^if($types){
		^types.foreach[i;type]{
			^if(!$type){^continue[]} 
			^self.__prepare_seo_parts_query[$type;$case;$gender]
		}
	}

	^rem{*** разбираем характеристки ***}
	$prefix_values_by_property[^hash::create[]]
	$postfix_values_by_property[^hash::create[]]

	$prefixes_amount(0)

	$all_values[^array::create[]]

	^text_params.values.foreach[property_id;values]{
		^if(!$values){	^continue[]	}

		$prefix_values_by_property.[$property_id][^array::create[]]
		$postfix_values_by_property.[$property_id][^array::create[]]

		^foreach[$values;value]{
			^self.__prepare_seo_parts_query[$value;$case;$gender]

			^all_values.add[^value.format_seo_name[$NULL]]

			^if($value.is_prefix && $prefixes_amount < 10){
				^prefix_values_by_property.[$property_id].add[$value]
				^prefixes_amount.inc[]
				^continue[]
			}

			^postfix_values_by_property.[$property_id].add[$value]
		}
	}

	$properties[$text_params.properties]

	^rem{*** подготавливаем словоформы для строки с кол-вом ***}
	^if($text_params.amount > 0){
		$case_for_amount_str[^sPattern.match[^^.*?\{amount_postfix\|(.+?)\}.*?^$][g]]
		^if($case_for_amount_str){
			$case_for_amount_str[$case_for_amount_str.1]
		}{
			$case_for_amount_str[$NULL]
		}

		^if($types){
			^types.foreach[i;type]{
				^if(!$type){^continue[]}
				^self.__prepare_seo_parts_query[$type;$case_for_amount_str;$gender]
			}
		}
	}

	^rem{*** ищем недостающие словоформы в справочнике ***}
	^self.__execute_seo_parts_query[]


	^rem{*** строим части фразы ***}
	$result[^hash::create[]]
	
	$result.types_str[]
	^if($types){
		$result.types_str[^types.foreach[i;type]{^if(!$type){^continue[]} ^self.__insert_seo_name_for_object[$type;$case;$gender]}{^if($i == $types - 1){ и }{, }}]
	}

	$result.prefix_values_str[]
	^if($prefix_values_by_property){
		$result.prefix_values_str[^prefix_values_by_property.foreach[property_id;prefixes]{ ^if(!$prefixes){^continue[]} ${properties.[$property_id].meta_text}^prefixes.foreach[i;value]{ ^self.__insert_seo_name_for_object[$value;$case;$gender]}{^if($i == $prefixes - 1){ и }{, }}}]
	}

	$result.postfix_values_str[]
	^if($postfix_values_by_property){
		$result.postfix_values_str[^postfix_values_by_property.foreach[property_id;postfixes]{
			^if(!$postfixes){^continue[]}

			$property[$properties.[$property_id]]
			${property.meta_text}
			^if($property.property_type_id == 2 && ($property.value_type_id == 2 || $property.value_type_id == 3)){
				$range[	$.0($postfixes.0.value)	]
				^if($postfixes > 1){
					^if($postfixes.1.value > $range.0){
						$range.1[$postfixes.1.value]
					}($postfixes.1.value < $range.0){
						$range.1[$range.0]
						$range.0[$postfixes.1.value]
					}
				}
				^if(!def $property.meta_text){^property.name.lower[]}
				^if($range > 1){
					от $range.0 до $range.1
				}{
					$range.0
				}
				${property.unit}
			}{
				^postfixes.foreach[i;value]{ ^self.__insert_seo_name_for_object[$value;$case;$gender]}{^if($i == $postfixes - 1){ и }{, }}
			}
		}]		
	}

	$result.all_values_str[]
	^if($all_values){
		$result.all_values_str[ ^all_values.foreach[i;str]{^str.trim[]}{^if($i == $text_params.all_values - 1){ и }{, }}]
	}

	$result.countries_str[]
	^if($text_params.countries){
		$result.countries_str[ из^text_params.countries.foreach[i;country]{ $country.name_genitive}{^if($i == $text_params.countries - 1){ и }{, }}]
	}

	$result.brands_str[]
	^if($text_params.brands){
		$result.brands_str[ ^text_params.brands.foreach[i;brand]{^brand.name.trim[]}{^if($i == $text_params.brands - 1){ и }{, }}]
	}

	$result.categories_str[]
	^if($text_params.categories){
		$result.categories_str[ ^text_params.categories.foreach[i;category]{^category.format_seo_name[]}{^if($i == $text_params.categories - 1){ и }{, }}]
	}

	$result.price_str[]
	^if(^text_params.price.min.int(0) || ^text_params.price.max.int(0)){
		$result.price_str[ по цене^if($text_params.price.min){ от ${text_params.price.min}}^if($text_params.price.max && $text_params.price.max != $text_params.price.min){ до ${text_params.price.max}} руб]
	}

	$result.price_min_str[]
	^if(^text_params.price.min.int(0)){
		$result.price_min_str[ цена от ${text_params.price.min} руб]
	}

	$result.simple_price_str[]
	^if(^text_params.price.min.int(0)){
		$result.simple_price_str[ ${text_params.price.min} руб]
	}

	$result.amount_str[]
	^if($text_params.amount > 0){
		$types_str_for_amount_str[]
		^if($types){
			$types_str_for_amount_str[^types.foreach[i;type]{^if(!$type){^continue[]} ^self.__insert_seo_name_for_object[$type;$case_for_amount_str;$gender]}{^if($i == $types - 1){ и }{, }}]
		}

		$amount_postfix[^num_decline[$text_params.amount;наименование;наименования;наименований]]

		$result.amount_str[${text_params.amount} ${amount_postfix} ${types_str_for_amount_str}]
	}
#end @__prepare_phrase_parts[]



##############################################################################
# Подготавливаем шаблон
##############################################################################
@__prepare_pattern[sPatternName]
	^rem{*** подбираем шаблон ***}
	$pattern[$self.patterns.[$sPatternName]]
	^if(!$pattern){
		^throw[ErrorSeoGenerator;ErrorSeoGenerator;Unknown pattern ${sPatternName}]
	}

	$result[$pattern.pattern]

	^rem{*** подключаем вложенные шаблоны ***}
	$cycle_num(1)
	^while(true){
		$subpatterns[^result.match[\{pattern\|(.+?)\}][g]]
		^if(!$subpatterns || $cycle_num > 5){ ^break[] }

		^subpatterns.menu{
			$subpattern[$self.patterns.[$subpatterns.1]]
			
			^if(!$subpattern){ ^continue[] }
			
			$subpattern_match[^result.match[^^(.*?)\{pattern\|${subpatterns.1}\}(.*?)^$][g]]
			$result[${subpattern_match.1}${subpattern.pattern}${subpattern_match.2}]
		}

		^cycle_num.inc[]
	}
#end @__prepare_pattern[sPattern]



##############################################################################
# По типам определеям падеж и род
##############################################################################
@__prepare_gender_and_case[sPattern;aTypes]
	$result[
		$.gender[$self.DEFAULT_GENDER]
		$.case[$self.DEFAULT_CASE]
	]

	^rem{*** определяем род ***}
	^if(def $aTypes.0.gender){
		$result.gender[${aTypes.0.gender}]
	}
	^if($aTypes > 1){
		$result.gender[multiple]
	}

	^rem{*** определяем склонение ***}
	$case_match[^sPattern.match[^^.*?\{type\|(.+?)\}.*?^$][g]]
	$result.case[$case_match.1]
#end @__prepare_gender_and_case[aTypes]



##############################################################################
# Производим замену в шаблоне
##############################################################################
@__replace_meta_phrases[sPattern;hPhraseParts]
	$result[$sPattern]
	$result[^result.match[\{categories\}][g]{$hPhraseParts.categories_str}]
	$result[^result.match[\{prefixes\}][g]{$hPhraseParts.prefix_values_str}]
	$result[^result.match[\{type\|(.+?)\}][g]{$hPhraseParts.types_str}]
	$result[^result.match[\{postfixes\}][g]{$hPhraseParts.postfix_values_str}]
	$result[^result.match[\{brands\}][g]{$hPhraseParts.brands_str}]
	$result[^result.match[\{countries\}][g]{$hPhraseParts.countries_str}]
	$result[^result.match[\{price\}][g]{$hPhraseParts.simple_price_str}]
	$result[^result.match[\{prices\}][g]{$hPhraseParts.price_str}]
	$result[^result.match[\{price_min\}][g]{$hPhraseParts.price_min_str}]
	$result[^result.match[\{all_values\}][g]{$hPhraseParts.all_values_str}]
	$result[^result.match[\{amount_postfix\|(.+?)\}][g]{$hPhraseParts.amount_str}]
#end @__replace_meta_phrases[]



##############################################################################
# Кэширует параметры для построения seo-текстов
##############################################################################
@prepare_seo_params[hParams]
	$self._seo_params[^hash::create[$hParams]]
#end @prepare_seo_params[hParams]



##############################################################################
# Инициализация запроса для словоформ
##############################################################################
@__init_seo_parts_query[]
	$self._query_is_empty(true)
	$self._query[^SqlCondition::create(false)]
#end @__init_seo_parts_query[]



##############################################################################
# Строит запрос на получение словоформ
##############################################################################
@__prepare_seo_parts_query[oObject;sCase;sGender]
	^rem{*** ищем слоформу в кэше ***}
	$cache_key[${oObject.CLASS_NAME}_${oObject.id}_${sCase}_${sGender}]

	$seo_part[$self._seo_text_parts.[$cache_key]]

	^rem{*** ищем в слофоформы в справочнике ***}
	^if(!def $seo_part && def $sCase){
		^rem{*** делаем запись в кэше - словоформа ищется в справочнике  ***}
		$self._seo_text_parts.[$cache_key](false)

		$self._query_is_empty(false)
		^self._query.add[
			object_class = "$oObject.CLASS_NAME" AND
			object_id = $oObject.id AND
			case_name = "$sCase"
		]
	}
#end @__prepare_seo_parts_query[]



##############################################################################
# Строит запрос на получение словоформ
##############################################################################
@__execute_seo_parts_query[]
	^if(!$self._query_is_empty){
		$seo_text_parts[^SeoTextPart:all[
			$.condition[$self._query]
		]]

		^foreach[$seo_text_parts;seo_text_part]{
			^rem{*** записываем в кэш все словоформы для выбранного падежа ***}
			^foreach[$self.genders;gender]{
				$self._seo_text_parts.[${seo_text_part.object_class}_${seo_text_part.object_id}_${seo_text_part.case_name}_${gender}][^seo_text_part.part_for_text[$gender]]
			}			
		}

		^rem{*** сбрасываем запрос на получение словоформ ***}
		^self.__init_seo_parts_query[]
	}
#end @__execute_seo_parts_query[]



##############################################################################
# Получает строку, соответсвующую заданному роду и падежу для объекта
##############################################################################
@__insert_seo_name_for_object[oObject;sCase;sGender]
	^rem{*** ищем словоформу для названия объекта в кэше ***}
	$result[$self._seo_text_parts.[${oObject.CLASS_NAME}_${oObject.id}_${sCase}_${sGender}]]

	^rem{*** заменяем запись о пустой словоформе на пустую строку ***}
	^if($result is bool){
		$result[$NULL]
	}

	^rem{*** передаем название на индивидуальное форматирование объекту ***}
	$result[^oObject.format_seo_name[$result]]
#end @__insert_seo_name_for_object[]



##############################################################################
# Метод подготавливает текст (типограф)
##############################################################################
@static:prepare_catalog_text[sText]
	$result[$sText]

	$result[^result.match[\s{2,}][g]{ }]
	$result[^result.match[\s,][g]{,}]
	$result[^result.trim[]]

	$result[^self.capitalize[$result]]
#end @prepare_catalog_text[]



###########################################################################
# Метод конвертирует первую буквы фразы в верхний регистр
##############################################################################
@static:capitalize[sText]
	$sText[^sText.trim[]]

	$result[^if(def $sText){^sText.match[^^(.{1})][g]{^match.1.upper[]}}]
#end of @uncapitalize[]