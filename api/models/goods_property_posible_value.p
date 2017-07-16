##############################################################################
#	
##############################################################################

@CLASS
GoodsPropertyPosibleValue

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[goods_property_id][
		$.type[int]
	]
	^field[code][
		$.type[string]
	]
	^field[name][
		$.type[string]
	]
	^field[icon_file_name][
		$.type[string]
	]
    ^field[val_int][
        $.type[int]
    ]
	^field[val_double][
		$.type[double]
	]
	^field[val_date][
		$.type[date]
	]
    ^field[val_string][
    	$.type[string]
    ]
    ^field[val_text][
    	$.type[string]
    ]
	^field[sort_order][
		$.type[int]
	]
	^field[is_prefix][
		$.type[bool]
	]

	^rem{ *** ассесоры *** }
	^field_accessor[value]

	^rem{ *** ассоциации *** }
    ^belongs_to[property][
		$.class_name[GoodsProperty]
	]
	^rem{ *** TODO: condition by property_id *** }
	^has_many[values][
		$.class_name[GoodsPropertyValue]

		$.dependent[destroy]
	]
	^has_many[seo_text_parts][
		$.class_name[SeoTextPart]
		$.foreign_key[object_id]
		$.condition[object_class = "GoodsPropertyPosibleValue"]
	]

	^rem{ *** валидаторы *** }
	^validates_presence_of[goods_property_id]
	^validates_presence_of[code][
		$.on[update]
	]
	^validates_uniqueness_of[code][
		$.scope[goods_property_id]
	]
	^validates_file_of[icon]
	^validates_image_of[icon]

	^has_attached_image[icon][
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
		$.flag[
			$.0[
				$.action[resize]

				$.width[30]
				$.height[20]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.usage[
			$.0[
				$.action[resize]

				$.width[32]
				$.height[27]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
	]
	
	^rem{ *** scopes *** }
	^scope[sorted][
		$.order[sort_order]
	]
#end @auto[]



##############################################################################
@GET_value[][result]
	^switch($self.property.value_type_id){
		^case(1){
			$self.val_int
		}
		^case(2){
			$self.val_int
		}
		^case(3){
			$self.val_double
		}
		^case(4){
			^dtf:format[%d.%m.%Y;$self.val_date]
		}
		^case(5){
			$self.val_string
		}
		^case(6){
			$self.val_text
		}
	}
#end @GET_value[]



##############################################################################
@SET_value[value]
	^switch($self.property.value_type_id){
		^case(1){
			$self.val_int[$value]
		}
		^case(2){
			$self.val_int[$value]
		}
		^case(3){
			$self.val_double[$value]
		}
		^case(4){
			$self.val_date[$value]
		}
		^case(5){
			$self.val_string[$value]
		}
		^case(6){
			$self.val_text[$value]
		}
	}
#end @SET_value[]



##############################################################################
@GET_full_name[]
	$result[<strong>$self.property.name</strong>: <span>$self.value $self.property.unit</span>]
#end @GET_full_name[]



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
	^if($self.is_new){
		^rem{ *** определяем sort_order *** }
		$self.sort_order(^oSql.int{SELECT MAX(sort_order) FROM $self.table_name WHERE goods_property_id = ^self.goods_property_id.int(0)}[ $.default(0) ] + 1)
	}
#end @before_save[]



##############################################################################
@GET_ALL_MAP[]
    ^if(!$self._all){
        $values[^self.find[
            $.include[property]
            $.join[property]
            $.order[property.sort_order ASC]
        ]]

        $self._all[^hash::create[]]
        ^foreach[$values;value]{
            $self._all.[$value.id][$value.property.name: $value.value]
        }
    }

    $result[$self._all]
#end @GET_ALL_MAP[]



##############################################################################
@format_seo_name[sSeoName]
	$result[$sSeoName]

	^rem{*** если словоформа не подобралась - используем значение по-умолчанию ***}
	^if(!def $result){
		$result[$self.value]
	}

	^rem{*** учитываем префиксный признак и добавляем единицу измерения ***}
	^if(!$self.is_prefix && def $self.property.unit){
		$result[$result $self.property.unit]
	}
#end @format_seo_name[]