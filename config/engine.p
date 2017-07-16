$OBJECT_TYPES[^enum::create[
	$.page[
		$.id[3]
		$.name[Типовая страница]
		$.class_name[Page]
		$.form[page_form]

		$.show_template_select(true)
		$.template_id(1)

		$.show_data_process_select(true)
		$.data_process_id(1)

#		$.show_fake_choose(true)

		^rem{ *** обязателен путь *** }
#		$.presence_of_permalink(true)

		^rem{ *** отображать форму для permalink *** }
#		$.show_permalink(false)

		^rem{ *** генерировать permalink автоматически *** }
#		$.permalink_generator(true)

		^rem{ *** не показывать навигаторы *** }
#		$.show_navigations_select(false)

		^rem{ *** стандартный набор навигаторов *** }
#		$.standart_navigation_selected[ $.1(true) ]

		^rem{ *** не показывать опубликованность *** }
		^rem{ *** стандартный флаг опубликованности *** }
	]
	$.group[
		$.id[4]
		$.name[Группа товаров]
		$.class_name[Page]
		$.form[catalog_form]

		$.template_id(4)
		$.data_process_id(3)
		
		$.show_fake_choose(true)

		$.presence_of_permalink(true)
#		$.show_permalink(false)
		$.permalink_generator(true)

		$.standart_navigation_selected[
			$.1(true)
			$.2(true)
		]
	]
	$.blog[
		$.id[5]
		$.name[Блог]
		$.class_name[Page]
		$.form[page_form]

#		$.show_template_select(true)
		$.template_id(6)
		$.data_process_id(1)

		$.presence_of_permalink(true)
#		$.show_permalink(false)
		$.permalink_generator(true)

		$.show_navigations_select(false)
	]
	$.news[
		$.id[6]
		$.name[Страница с новостями]
		$.class_name[Page]
		$.form[page_form]

		$.template_id(2)
		$.data_process_id(2)

		$.presence_of_permalink(true)
		$.permalink_generator(true)

		$.show_navigations_select(false)
	]
	$.fast_filters_group[
		$.id[7]
		$.name[Группа быстрых фильтров]
		
		$.navigations[
			$.1(true)
		]
	]
	$.fast_filter[
		$.id[8]
		$.name[Быстрый фильтр]
		$.class_name[JumpFilter]
		$.form[jump_filter_form]
		
#		$.show_navigations_select(false)
#		$.show_navigations_select(false)
		
		$.navigations[
			$.1(true)
		]
	]
	
	$.link_to_object[
		$.id[1]
		$.name[Ссылка на объект]
	]
	$.link_to_url[
		$.id[2]
		$.name[Ссылка на URL]
	]
]]


$OBJECT_TEMPLATES[
	$.1[
		$.name[Типовая страница]
		$.layout[page]
		$.file_name[page]
	]
#	$.3[
#		$.name[Страница во всю ширину]
#		$.layout[standart]
#		$.file_name[page]
#	]
	$.2[
		$.name[Страница с новостями]
		$.layout[news]
		$.file_name[index]
	]

	$.4[
		$.name[Группа товаров]
		$.layout[catalog]
		$.file_name[catalog]
	]
]


$OBJECT_PROCESSES[
	$.1[
		$.name[Типовая страница]
		$.file_name[page]
	]
	$.2[
		$.name[Новости]
		$.file_name[news]
	]
]
