$MAILING_LAYOUTS[^array::create[]]

^MAILING_LAYOUTS.add[
	$.id(1)
	$.name[Основной шаблон]
	$.layout[standart]
	$.file_name[standart]
]

$MESSAGE_LAYOUTS_BY_ID[^MAILING_LAYOUTS.hash[id]]