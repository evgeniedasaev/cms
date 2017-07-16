##############################################################################
#
##############################################################################

@CLASS
Goods

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	$self.IN_STOCK_STATE[
		$.0[Нет]
		$.1[Мало]
		$.2[Много]
		$.3[Очень много]
	]

	^rem{ *** аттрибуты *** }
	^field[parent_id][
		$.type[int]
	]
	^field[type_id][
		$.name[goods_type_id]
		$.type[int]
	]
	^field[type_prefix][
		$.type[string]
	]
	^field[category_id][
		$.type[int]
	]
	^field[permalink][
		$.type[string]
	]
	^field[code][																^rem{ *** артикул *** }
		$.type[string]
	]
	^field[brand_id][															^rem{ *** бренд *** }
		$.type[int]
	]
	^field[model][																^rem{ *** модель *** }
		$.type[string]
	]
	^field[name][																^rem{ *** полное наименование *** }
		$.type[string]
	]
	^field[postfix][
		$.type[string]
	]
	^field[price][																^rem{ *** цена в базовой валюте *** }
		$.type[double]
	]
	^field[price_cur][
		$.type[double]
	]
	^field[price_cur_id][
		$.type[int]
	]
	^field[price_old][															^rem{ *** старая цена в базовой валюте *** }
		$.type[double]
	]
	^field[price_old_cur][
		$.type[double]
	]
	^field[price_old_cur_id][
		$.type[int]
	]
	^field[cost][																^rem{ *** себестоимость в базовой валюте *** }
		$.type[double]
	]
	^field[cost_cur][
		$.type[double]
	]
	^field[cost_cur_id][
		$.type[int]
	]
	^for[i](1;3){
		^field[variation_property_id_${i}][
			$.name[goods_variation_property_id_${i}]
			$.type[int]
		]
	}
	^for[i](1;3){
		^field[property_value_id_${i}][
			$.type[int]
		]
	}
	^field[in_stock][															^rem{ *** количество на складе *** }
		$.type[int]
	]
	^field[reserved][															^rem{ *** зарезервированное количество *** }
		$.type[int]
	]
	^field[stock_status][														^rem{ *** доступное для заказа количество *** }
		$.type[int]
	]
	^field[delivery_days][
		$.type[int]
	]
#	^field[stock_boundary][
#		$.type[int]
#	]
#	^field[partner_in_stock][
#		$.type[int]
#	]
	^field[description][
		$.type[string]
	]
	^field[body][
		$.type[string]
	]

#	^field[is_available_on_request][
#		$.type[bool]
#	]
	^field[is_published][
		$.type[bool]
	]
	^field[is_complect][
		$.type[bool]
	]
	^field[is_recommended][														^rem{ *** флаг рекомендуем *** }
		$.type[bool]
	]	
	^field[availability_status][												^rem{ *** флаг доступности товара *** }
		$.type[bool]
		$.is_protected(true)
	]

	^field[dt_create][
		$.type[date]
		$.is_protected(true)
	]
	^field[dt_update][
		$.type[date]
		$.is_protected(true)
	]

	^rem{ *** ассесоры *** }
#	^field_accessor[categories]

	^rem{ *** валидаторы *** }
	^validates_numericality_of[type_id]
#	^validate_with[validate_category]
	^validates_numericality_of[category_id]
	^validates_presence_of[permalink][
		$.on[update]
	]
	^validates_uniqueness_of[permalink][
		$.scope[category_id]
	]
	^validates_uniqueness_of[code]
	^validate_with[validate_name]
	^validates_numericality_of[price_cur]
#	^validates_numericality_of[price_old_cur]
	^validates_numericality_of[cost_cur]
	^validate_with[validate_property_values_presence]
	^validate_with[validate_property_values_uniqueness]

	^rem{ *** связи *** }
	^belongs_to[parent][
		$.class_name[Goods]
		$.foreign_key[parent_id]

		$.touch[add_to_queue_update_by_variation]
	]
	^belongs_to[type][
		$.class_name[GoodsType]
		$.foreign_key[type_id]
	]
	^belongs_to[brand][
		$.class_name[Brand]
	]
	^belongs_to[category][
		$.class_name[Object]
		$.foreign_key[category_id]
	]
	^has_and_belongs_to_many[categories][
		$.class_name[Object]
		$.join_table[goods_to_category]

		$.after_save[save_base_category]
	]
	^has_many[property_values][
		$.class_name[GoodsPropertyValue]
		
		$.reverse_of[goods]
	]
	^has_many[colors_values][
		$.class_name[GoodsPropertyValue]
		$.condition[goods_property_id = $COLOR_PROPERTY_ID]
	]
	^has_many[goods_color][
		$.through[colors_values]
	]
	^for[i](1;3){
		^belongs_to[variation_property_${i}][
			$.class_name[GoodsProperty]
			$.foreign_key[variation_property_id_${i}]
		]
	}
	^for[i](1;3){
		^belongs_to[property_value_${i}][
			$.class_name[GoodsPropertyPosibleValue]
			$.foreign_key[property_value_id_${i}]
		]
	}
	^has_many[variations][
		$.class_name[Goods]
		$.foreign_key[parent_id]

		$.dependent[destroy]

		$.join[
			$.property_value_1[
				$.type[left]
			]
			$.property_value_2[
				$.type[left]
			]
			$.property_value_3[
				$.type[left]
			]
		]
		$.order[property_value_1.sort_order ASC, property_value_2.sort_order ASC, property_value_3.sort_order ASC]

		$.touch[add_to_queue_update_by_base_goods]
	]
	^has_many[variations_published][
		$.class_name[Goods]
		$.foreign_key[parent_id]

#		$.dependent[destroy]	^rem{ *** удаляиться через variations *** }

		$.join[
			$.property_value_1[
				$.type[left]
			]
			$.property_value_2[
				$.type[left]
			]
			$.property_value_3[
				$.type[left]
			]
		]
		$.condition[variations_published.is_published = 1]
#		$.order[property_value_1.sort_order ASC, property_value_2.sort_order ASC, property_value_3.sort_order ASC]
		$.order[CEIL((in_stock * price) / 10000) DESC, property_value_1.sort_order DESC, property_value_2.sort_order DESC, property_value_3.sort_order DESC]
	]
	^has_many[variations_availible][
		$.class_name[Goods]
		$.foreign_key[parent_id]

#		$.dependent[destroy]	^rem{ *** удаляиться через variations *** }

		$.join[
			$.goods[
				$.type[left]
			]
			$.property_value_1[
				$.type[left]
			]
			$.property_value_2[
				$.type[left]
			]
			$.property_value_3[
				$.type[left]
			]
		]
		$.condition[variations_availible.is_published = 1 AND variations_availible.availability_status = 1]
		$.order[property_value_1.sort_order ASC, property_value_2.sort_order ASC, property_value_3.sort_order ASC]
	]
	^has_and_belongs_to_many[base_colors][
		$.class_name[GoodsBaseColor]
		$.join_table[goods_base_color_to_goods]
	]
	^has_many[to_base_colors][
		$.class_name[GoodsBaseColorToGoods]

		$.dependent[destroy]
	]
	^has_and_belongs_to_many[complects][
		$.class_name[Goods]
		$.join_table[complect_to_goods]
		$.join_foreign_key[complect_id]
	]
	^has_and_belongs_to_many[goods_complect][
		$.class_name[Goods]
		$.join_table[complect_to_goods]
		$.association_join_foreign_key[complect_id]
	]
	^has_many[positions][
		$.class_name[ComplectToGoods]
		$.foreign_key[complect_id]

		$.dependent[destroy]
	]
	^has_many[to_goods_complect][
		$.class_name[ComplectToGoods]
		$.foreign_key[goods_id]

		$.dependent[destroy]
	]	
	^has_many[goods_associations][
		$.class_name[GoodsAssociation]
		$.include[goods]
		$.dependent[destroy]

		$.order[sort_order ASC]
	]
	^has_many[files][
		$.class_name[GoodsFile]
		$.condition[file_type_id != 0]
		$.order[sort_order ASC]

		$.dependent[destroy]
	]
	^has_many[images][
		$.class_name[GoodsFile]
		$.condition[file_type_id = 0]
		$.order[sort_order ASC]
	]
	^has_many[published_images][
		$.class_name[GoodsFile]
		$.condition[is_published = 1 AND file_type_id = 0]
		$.order[is_main DESC, sort_order ASC]
	]
	^has_one[image][
		$.class_name[GoodsFile]
		$.condition[file_type_id = 0 AND is_main = 1]
		$.order[sort_order ASC]
	]
	^has_and_belongs_to_many[variation_images][
		$.class_name[GoodsFile]
		$.association_join_foreign_key[goods_variation_id]
		$.join_table[goods_file_to_goods_variation]
		$.condition[file_type_id = 0]
	]
	^has_and_belongs_to_many[series][
		$.class_name[GoodsSerie]
		$.join_table[goods_serie_to_goods]
	]
#	^has_many[storage_movements][
#		$.class_name[StorageDocCart]
#	]
	^has_many[skus][
		$.class_name[SKU]

		$.order[price_cur DESC, in_stock DESC]
	]
#	^has_many[carts][
#		$.class_name[Cart]
#	]
	^has_many[favorites][
		$.class_name[GoodsFavorite]
	]


	^rem{ *** scope *** }
	^scope[published][
		$.condition[is_published = 1]
	]
	^scope[only_goods][
		$.condition[parent_id IS NULL]
	]
	^scope[only_variations][
		$.condition[parent_id IS NOT NULL]
	]
	^scope[availabiles][
		$.condition[goods.is_published = 1 AND goods.availability_status = 1]
	]
#end @auto[]



##############################################################################
@GET_base_goods[]
	^if($self.parent_id){
		$result[$self.parent]
	}{
		$result[$self]
	}
#end @GET_base_goods[]



##############################################################################
@GET_type_prefix_title[]
	$result[^if(def $self.type_prefix){$self.type_prefix}{$self.type.prefix}]
#end @GET_type_prefix_title[]



##############################################################################
@GET_variation_price_cur[]
	^if($self.parent_id && $self.price_cur){
		$result[$self.price_cur]
	}{
		$result[$self.base_goods.price_cur]
	}
#end @GET_variation_price_cur[]



##############################################################################
@GET_variation_price_cur_id[]
	^if($self.parent_id && $self.price_cur_id){
		$result[$self.price_cur_id]
	}{
		$result[$self.base_goods.price_cur_id]
	}
#end @GET_variation_price_cur_id[]



##############################################################################
@GET_variation_price[]
	^if($self.parent_id && $self.price){
		$result[$self.price]
	}{
		$result[$self.base_goods.price]
	}
#end @GET_variation_price[]



##############################################################################
@GET_variation_price_purchasing[]
	^if($self.parent_id && $self.price_purchasing){
		$result[$self.price_purchasing]
	}{
		$result[$self.base_goods.price_purchasing]
	}
#end @GET_variation_price_purchasing[]



##############################################################################
@GET_variation_price_currency[]
	^if($self.parent_id && $self.price){
		$result[$Currency:all.[$self.price_cur_id]]
	}{
		$result[$Currency:all.[$self.base_goods.price_cur_id]]
	}
#end @GET_variation_price_currency[]



##############################################################################
@GET_price_currency[]
	$result[$Currency:all.[$self.price_cur_id]]
#end @GET_price_currency[]



##############################################################################
@GET_price_old_currency[]
	$result[$Currency:all.[$self.price_old_cur_id]]
#end @GET_cost_currency[]



##############################################################################
@GET_cost_currency[]
	$result[$Currency:all.[$self.cost_cur_id]]
#end @GET_cost_currency[]



##############################################################################
@GET_availible_for_order[]
	^rem{ *** вычисляем доступное для заказа количество товаров *** }
	$result($self.stock_status)

	^rem{ *** если товар под заказ, то он всегда доступен *** }
	^if($self.is_available_on_request && !$result){
		$result(10000)
	}
#end @GET_availible_for_order[]



##############################################################################
@GET_code_auto[]
	$result[^if(def $self.parent.code){${self.parent.code}-}^for[i](1;3){^if(!$self.[property_value_$i]){^continue[]}$self.[property_value_$i].code}[-]]
#end @GET_code_auto[]



##############################################################################
@GET_variation_name_auto[]
	$result[^for[i](1;3){^if(!$self.[property_value_$i]){^continue[]}^[$self.[property_value_$i].description^]}[ ]]
#end @GET_variation_name_auto[]



##############################################################################
@GET_variation_name[]
	$result[$self.base_goods.clear_title^if(def $self.model){ $self.model}]
#end @GET_variation_name[]



##############################################################################
@GET_variation_title[]
	$result[$self.base_goods.title^if(def $self.model){, $self.model}]
#end @GET_variation_name[]



##############################################################################
@GET_variaiton_hash[]
	^if($self.variation_property_1){
		$result[^self.variations.hash[property_value_id_1][ $.type[array] ]]

		^if($self.variation_property_2){
			^result.foreach[k1;v1]{
				$result.[$k1][^v1.hash[property_value_id_2][ $.type[array] ]]
			}
		}

		^if($self.variation_property_3){
			^result.foreach[k1;v1]{
				^v1.foreach[k2;v2]{
					$result.[$k1].[$k2][^v2.hash[property_value_id_3][ $.type[array] ]]
				}
			}
		}
	}{
		$result[^hash::create[]]
	}
#end @GET_variaiton_hash[]



##############################################################################
@GET_variaiton_published_hash[]
	^if($self.variation_property_1){
		$result[^self.variations_published.hash[property_value_id_1][ $.type[array] ]]

		^if($self.variation_property_2){
			^result.foreach[k1;v1]{
				$result.[$k1][^v1.hash[property_value_id_2][ $.type[array] ]]
			}
		}

		^if($self.variation_property_3){
			^result.foreach[k1;v1]{
				^v1.foreach[k2;v2]{
					$result.[$k1].[$k2][^v2.hash[property_value_id_3][ $.type[array] ]]
				}
			}
		}
	}{
		$result[^hash::create[]]
	}
#end @GET_variaiton_published_hash[]



##############################################################################
@GET_variation_availible_hash[]
	^if($self.variation_property_1){
		$result[^self.variations_availible.hash[property_value_id_1][ $.type[array] ]]

		^if($self.variation_property_2){
			^result.foreach[k1;v1]{
				$result.[$k1][^v1.hash[property_value_id_2][ $.type[array] ]]
			}
		}

		^if($self.variation_property_3){
			^result.foreach[k1;v1]{
				^v1.foreach[k2;v2]{
					$result.[$k1].[$k2][^v2.hash[property_value_id_3][ $.type[array] ]]
				}
			}
		}
	}{
		$result[^hash::create[]]
	}
#end @variation_availible_hash[]



##############################################################################
@validate_category[hParams]
	^if(!$self.parent_id && !$self.category_id){
		^self.errors.append[category_id_empty;category_id;category_id empty]
	}
#end @validate_category[]



##############################################################################
@validate_name[hParams]
	^if(!$self.parent_id && !def $self.model){
		^self.errors.append[model_empty;model;model empty]
	}
#end @validate_name[]



##############################################################################
#	Метод проверяет обязательность заполненности всех значений свойств варианта
##############################################################################
@validate_property_values_presence[hParams]
	^if($self.parent_id){
		^for[i](1;3){
			$property[$self.parent.variation_property_$i]
			$value[$self.property_value_id_$i]

			$return($property && !^value.int(0))

			^if($return){
				^break[]
			}
		}

		^if($return){
			^self.errors.append[property_values_empty;^for[i](1;3){property_value_id_$i}[,];property_values empty]
		}
	}
#end @validate_property_values_presence[]



##############################################################################
#	Метод проверяет уникальность значений свойств вариантов
##############################################################################
@validate_property_values_uniqueness[hParams]
	^if($self.parent_id){
		^if(^self.CLASS.count[
			$.condition[`$self.table_name`.`parent_id` = ^self.parent_id.int(0) AND ^for[i](1;3){`$self.table_name`.`property_value_id_$i` = ^self.[property_value_id_$i].int(0) AND} `$self.table_name`.`$primary_key` != ^self.id.int(0)]
		]){
			^self.errors.append[property_values_exist;^for[i](1;3){property_value_id_${i}}[,];property_values not unique]
		}
	}
#end @validate_property_values[]



##############################################################################
@GET_property_values_hash[]
	^if(!$self._property_values_hash){
		$self._property_values_hash[^self.property_values.hash{$v.property.code}[ $.type[array] $.bJunction(true) $.value[v] ]]
	}
	$result[$self._property_values_hash]
#end @GET_property_values_hash[]



##############################################################################
@GET_clear_title[]
	$result[^if(def $self.name){${self.name}}{^if($self.brand){$self.brand.name }${self.model}}]
#end @GET_clear_title[]



##############################################################################
@GET_mini_title[]
	$result[^if(def $self.name){$self.name}{«${self.clear_title}»^if(def $self.postfix){ $self.postfix}}]
#end @GET_mini_title[]



##############################################################################
@GET_title[]
	$result[$self.mini_title]
#end @GET_title[]



##############################################################################
@GET_full_title[]
#	$property[$self.base_goods.[variation_property_1]]
#	$value[$self.[property_value_1]]
	$result[^if(def $self.name){$self.name}{^if(def $self.type_prefix_title){$self.type_prefix_title }$self.title}]
	$result[^result.trim[left;«]]
	$result[^result.trim[right;»]]
#end @GET_full_title[]




##############################################################################
@GET_min_discount[]
	$result((1 - $self.cost/$self.price) * 100)
#end @GET_min_discount[]



##############################################################################
@GET_stock_status_info[]
	$result[$STOCK_STATUS.[$self.stock_boundary]]

	^rem{*** используем кол-во дней доставки ***}
	^if($self.stock_boundary == 100){
		$dt_delivery[^date::now($self.delivery_days + 1)]
		$result.description[Под заказ ^dtf:format[%d.%m][$dt_delivery]]

		$result.tooltip[^result.tooltip.match[<delivery_days>][gi]{${self.delivery_days} ^num_decline[$self.delivery_days][дня;дней;дней]}]
	}
#end @GET_stock_status_info[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	$self.dt_create[^date::now[]]
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]

	^rem{*** если есть родитель - берем от него значения для бренда, категории, имя, модель ***}
	^if($self.parent){
		^self.update_by_base_goods[]
	}{
		^if(!def $self.permalink){
			^rem{ *** генерируем permalink путем транслита названия и удаления запрещенных символов *** }
			$self.permalink[^Urlify:urlify[$self.model]]
		}

		$permalink[$self.permalink]

		$i(0)
		^while(^Goods:find_by_permalink[$self.permalink][ $.condition[goods_id != ^self.id.int(0)] ]){
			^i.inc[]
			$self.permalink[${permalink}-${i}]
		}

		^if(!def $self.permalink){
			^throw_inspect[NO PERMALINK]
		}
	}

	^rem{ *** обновляем цены в базовой валюте *** }
	^if($self.price_cur || $self.price_cur != $self.price_cur_was || !$self.parent_id){
		$self.price($self.price_cur * $self.price_currency.rate)
	}
	^if($self.price_old_cur || $self.price_old_cur != $self.price_old_cur_was || !$self.parent_id){
		$self.price_old($self.price_old_cur * $self.price_old_currency.rate)
	}
	^if($self.cost_cur || $self.cost_cur != $self.cost_cur_was || !$self.parent_id){
		$self.cost($self.cost_cur * $self.cost_currency.rate)
	}

	^rem{ *** обнуление цены old_price в случае понижения цена price *** }
	^if($self.price_old <= $self.price){
		$self.price_old(0)
	}

	^rem{ *** вычисляем доступный остаток склада *** }
	$self.stock_status($self.in_stock - $self.reserved)

	^rem{ *** вычисляем флаг доступности товара для продажи *** }
	$self.availability_status($self.stock_status > 0 || $self.is_available_on_request || $self.partner_in_stock)

	$self.stock_boundary(0)														^rem{ *** нет в наличии *** }

	^if($self.in_stock){
		$self.stock_boundary(1)													^rem{ *** в наличии *** }
	}(!$self.in_stock && $self.is_available_on_request){
		$self.stock_boundary(99)												^rem{ *** если "Доступна под заказ" без остатка, то Доступна со специальным статусом *** }
	}($self.delivery_days){
		$self.stock_boundary(100)												^rem{ **под заказ *** }
	}
#end @before_save[]



##############################################################################
@save_base_category[]
	^rem{ *** обновляем только основную категорию *** }
	^if($self.category){
		^self.categories.add[$self.category.object]
	}
#end @save_base_category[]



##############################################################################
@after_save[]
	^BASE:after_save[]

	^if(!$self.parent_id){
		^save_base_category[]
	}{
		^rem{ *** создаем значения характеристик для всех вариантов *** }
		^for[i](1;3){
			$property[$self.parent.variation_property_$i]
			$value[$self.property_value_id_$i]

			^if(!$property || !$value){^continue[]}

			^rem{ *** проверяем наличие такого значения *** }
			$property_value[^self.base_goods.property_values.find_first[
				$.condition[goods_property_id = $property.id AND `$property.val_field` = $value]
			]]
			^if($property_value){^continue[]}

			$property_value[^GoodsPropertyValue::create[]]

			$property_value.goods_id[$self.base_goods.id]
			$property_value.goods_property_id[$property.id]
			$property_value.value[$value]

			^if(!^property_value.save[]){
				^throw_inspect[^property_value.errors.array[]]
			}
		}
	}
#end @after_save[]



##############################################################################
#	Метод вызывается как touch для обнволения Корневого товара по Вариантам
##############################################################################
@update_by_variation[]
	^rem{ *** пересчитываем остатки на складе или в резерве *** }
	$stock[^Goods:plug[
		$.column[
			$.in_stock[SUM(in_stock)]
			$.reserved[SUM(reserved)]
		]
		$.condition[parent_id = $self.id AND is_published = 1 ^rem{ ***  AND stock_status > 0 *** }]
	]]

	$self.in_stock($stock.in_stock)
	$self.reserved($stock.reserved)

	^if(!^self.save[]){
		^throw_inspect[^self.errors.array[]]
	}
#end @update_by_variation[]



##############################################################################
#	Метод вызывается как touch для обнволения Корневого товара по Вариантам
##############################################################################
@add_to_queue_update_by_variation[]
#	$operataion[^QueueTouch:add_to_queue[$self;update_by_variation]]
	^self.update_by_variation[]
#end @add_to_queue_update_by_variation[]



##############################################################################
#	Метод вызывается как touch для обновления Вариантов по Корневому товару
##############################################################################
@update_by_base_goods[]
	^rem{ *** обновляем поля в соответствии с данными родительского товара *** }
	$self.type_id($self.parent.type_id)
	$self.type_prefix[$self.parent.type_prefix]
	$self.postfix[$self.parent.postfix]
	$self.category_id($self.parent.category_id)
	$self.brand_id($self.parent.brand_id)

	$self.code[$self.code_auto]
	$self.model[$self.variation_name_auto]									^rem{ *** в варианте храним название варианта (по параметрам) *** }
	$self.name[$self.variation_name]

#	$self.is_available_on_request($self.parent.is_available_on_request || $self.partner_in_stock)
	^rem{*** если карточка не опубликована, то снимаем с публикации и варианты ***}
	$self.is_published($self.is_published && $self.parent.is_published)

	^if(!^self.save[]){
		^throw_inspect[^self.errors.array[]]
	}
#end @update_by_base_goods[]



##############################################################################
#	Метод вызывается как touch для обновления Вариантов по Корневому товару
##############################################################################
@add_to_queue_update_by_base_goods[]
#	$operataion[^QueueTouch:add_to_queue[$self;update_by_base_goods]]
	^self.update_by_base_goods[]
#end @add_to_queue_update_by_base_goods[]



##############################################################################
#	Метод вызывается как touch для обновления Вариантов по Корневому товару
##############################################################################
@update_by_sku[]
	$price(0)
	$cost(0)
	$in_stock(0)
	$delivery_days(0)

	^foreach[$self.skus;sku]{
		^if(!def $self.code){
			$self.code[#$sku.id]
		}

		^rem{ *** остаток на складе - сумма всех остатков по SKU *** }
		^in_stock.inc($sku.in_stock)

		^rem{ *** цена продажи - берем максимальную из возможных *** }
		^if($sku.public_price && $price < $sku.public_price){
			$price($sku.public_price)

			^rem{ *** закупочную цену берем от той позиции, у которой цена продажи максимальна *** }
			$cost($sku.cost)
		}

		^rem{ *** срок доставки (считается равным нулю, если есть остатки на своем складе) *** }
		^if(!$delivery_days || $sku.delivery_days < $delivery_days){
			$delivery_days($sku.delivery_days)
		}
	}
	
	$self.in_stock($in_stock)
	$self.delivery_days($delivery_days)											^rem{ *** записываем срок доставки товаров у поставщика *** }

	^if($in_stock){																^rem{ *** если в наличии, то обновляем цены *** }
		^if($price){
			$self.price_cur($price)
			$self.price_cur_id[$Currency:ALL.RUB.id]
		}

		^if($cost){
			$self.cost_cur($cost)
			$self.cost_cur_id[$Currency:ALL.RUB.id]
		}
	}

	^if(!^self.save[]){
		^throw_inspect[^self.errors.array[]][^inspect[$self.attributes]]
	}
#end @update_by_sku[]



##############################################################################
@update_base_colors[]
	$base_colors[^GoodsBaseColor:all[
		$.condition[goods_base_color_id IN (0^foreach[$self.goods_color;color]{^foreach[$color.base_colors;base_color]{,$base_color.id}})]
	]]

	$self.base_colors[$base_colors]
#end @update_base_colors[]



##############################################################################
@update_complects_flag[]
	$r(^Goods:update_all[
		$.is_complect(^self.goods_complect.count[] > 0)
	][
		$.condition[goods_id = $self.id]
	])
#end @update_complects_flag[]



##############################################################################
@is_favorite_for[user]
	$result[^self.favorites.where[user_id = $user.id]]
#end @is_favorite_for[]



##############################################################################
@format_seo_name[sSeoName]
	$result[$sSeoName]

	^rem{*** если словоформа не подобралась - используем значение по-умолчанию ***}
	^if(!def $result){
		$result[$self.full_title]
	}
#end @format_seo_name[]



##############################################################################
#	Возвращает наличие акции по товару
##############################################################################
@GET_is_action[]
	$result($self.price_old)
#end @GET_is_action[]



##############################################################################
@GET_is_novelty[]
	$result((^date::now[] - $self.dt_create) <= 30)
#end @GET_is_novelty[]



##############################################################################
@prepare_for_api[]
    $result[^hash::create[$self.attributes]]

	$result.type_prefix_title[$self.type_prefix_title]
#end @prepare_for_api[]
