##############################################################################
# Настройки для правил роутинга в фильтра товаров
##############################################################################

$FILTER_PARAMS[^array::create[]]

$FILTER_DEFAULT_CONTROLLER[catalog]

^rem{*** 
	Добавление нового параметра
# 	^FILTER_PARAMS.add[
# 		$.is_property(1 - являятся свойством товара|0 - не является)
# 		$.property_id(ИДЕНТИФИКАТОР СВОЙТСВА ТОВАРА GoodsProperty)
# 		$.name[КОД ПАРАМЕТРА]
# 		$.default(true - обязательный параметр в url|false - не обязательный)
# 	]		
***}

^rem{*** категория ***}
^FILTER_PARAMS.add[
	$.name[group]
	$.default(true)
	$.pattern[catalog/[\w_\-]+]
]

^rem{*** тип ***}
^FILTER_PARAMS.add[
	$.name[type]
	$.default(false)
]

^rem{*** страна ***}
^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(3)
	$.name[country]
	$.default(false)
]

^rem{*** бренд ***}
^FILTER_PARAMS.add[
	$.name[brand]
	$.default(false)
]

^rem{*** материал ***}
^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(2)
	$.name[material]
	$.default(false)
]

^rem{*** тип плиты ***}
^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(29)
	$.name[plate_type]
	$.default(false)
]

^rem{*** тип напитка ***}
^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(24)
	$.name[drink_type]
	$.default(false)
]

^rem{*** кол-во предметов ***}
^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(4)
	$.name[qnt]
	$.default(false)
]

^rem{*** кол-во персон ***}
^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(5)
	$.name[qnt_person]
	$.default(false)
]

^rem{*** объем ***}
^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(15)
	$.name[volume]
	$.default(false)
]

^rem{*** эксплуатация ***}
^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(13)
	$.name[usage_microwave]
	$.default(false)
]

^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(14)
	$.name[usage_dishwasher]
	$.default(false)
]

^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(21)
	$.name[usage_deep_freeze]
	$.default(false)
]

^FILTER_PARAMS.add[
	$.is_property(1)
	$.property_id(20)
	$.name[usage_oven]
	$.default(false)
]

^rem{*** хэш содержащий элементы вида ИМЯ_ПАРАМЕТРА => ПАРАМЕТР ***}
$FILTER_PARAMS_BY_NAME[^FILTER_PARAMS.hash[name]]
