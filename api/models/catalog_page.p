##############################################################################
#
##############################################################################

@CLASS
CatalogPage

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[group_id][
		$.type[int]
	]
	^field[goods_serie_id][
		$.type[int]
	]
	^field[brand_id][
		$.type[int]
	]
	^for[i](1;3){
		^field[property_value_id_${i}][
			$.type[int]
		]
	}
	^field[name][
		$.type[string]
	]
	^field[title][
		$.type[string]
	]
	^field[meta_keywords][
		$.type[string]
	]
	^field[meta_description][
		$.type[string]
	]
	^field[header][
		$.type[string]
	]
	^field[body][
		$.type[string]
	]
	^field[dt_create][
		$.type[date]
	]
	^field[dt_update][
		$.type[date]
	]
	^field[is_published][
		$.type[bool]
	]
	^field[is_show_in_catalog_with_default_text][
		$.type[bool]
	]

	^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }
	^validates_presence_of[name]
	^validate_with[validate_by_unique]

	^belongs_to[brand]
	^belongs_to[serie][
		$.class_name[GoodsSerie]
		$.foreign_key[goods_serie_id]
	]
	^belongs_to[group][
		$.class_name[Object]
		$.foreign_key[group_id]
	]
	^for[i](1;3){
		^belongs_to[property_value_${i}][
			$.class_name[GoodsPropertyPosibleValue]
			$.foreign_key[property_value_id_${i}]
		]
	}

	^scope[sorted][
		$.order[dt_create DESC]
	]
	^scope[first_published][
		$.condition[is_published = 1]
		$.order[dt_update DESC]
		$.limit(1)
	]
#end @auto[]



##############################################################################
@validate_by_unique[hParams]
	^if(^self.CLASS.count[
		$.condition[
			brand_id = ^self.brand_id.int(0) AND
			goods_serie_id = ^self.goods_serie_id.int(0) AND
			group_id = ^self.group_id.int(0) AND
			^for[i](1;3){
				property_value_id_${i} = ^self.[property_value_id_${i}].int(0) AND
			}
			`$self.table_name`.`$primary_key` != ^self.id.int(0)
		]
	]){
		^self.errors.append[params_exist;params;page exist]
	}
#end @validate_by_unique[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.dt_create){
		$self.dt_create[^date::now[]]
	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]

	$properties[^hash::create[]]

	^for[i](1;3){
		^if(!$self.[property_value_id_${i}]){^continue[]}
		$properties.[$i][$self.[property_value_id_${i}]]
	}

	$properties_sorted[^sort_values[$properties]]

	^for[i](1;3){
		$self.[property_value_id_${i}][$properties_sorted.[$i]]
	}
#end @before_save[]



##############################################################################
#	Метод сортирует характеристики по значению
#	используется при создании, выборке
##############################################################################
@sort_values[hProperties][index;id]
	$result[^hash::create[]]
	
	$tProperties[^table::create{id}]
	
	^hProperties.foreach[index;id]{
		^tProperties.append{$id}
	}
	
	^tProperties.sort($tProperties.id)

	^tProperties.menu{
		$result.[^tProperties.line[]][$tProperties.id]
	}
#end @sort_values[aProperties]
