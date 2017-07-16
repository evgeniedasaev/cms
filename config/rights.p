##############################################################################
#	Права задаются в виде маски битов
#	id права обозначает бит, отвечающий за назначение права
#
#	type -> rights { right -> bit }
##############################################################################

$RIGHTS[^enum::create[
	$.Global[
		$.id[2001]
		$.code[Global]
		$.name[Глобальные права]

		$.rights[
			$.[external_usage][
				$.id[1]
				$.name[Доступ из вне]
				$.description[Возможность зайти в систему удаленно]
			]
		]
	]

^rem{ Разделы каталога  - 21**}

	$.Catalog[
		$.id[2101]
		$.code[Catalog]
		$.name[Каталог]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.Goods[
		$.id[2102]
		$.code[Goods]
		$.name[Товары]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsType[
		$.id[2103]
		$.code[GoodsType]
		$.name[Типы товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsPropertyPosibleValue[
		$.id[2104]
		$.code[GoodsPropertyPosibleValue]
		$.name[Возможные значения характеристик]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsBaseColor[
		$.id[2105]
		$.code[GoodsBaseColor]
		$.name[Базовые цвета товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsColor[
		$.id[2106]
		$.code[GoodsColor]
		$.name[Цвета товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsFile[
		$.id[2107]
		$.code[GoodsFile]
		$.name[Файлы товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsFileType[
		$.id[2108]
		$.code[GoodsFileType]
		$.name[Типы файлов товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsImage[
		$.id[2109]
		$.code[GoodsImage]
		$.name[Изображения товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsAssociation[
		$.id[2110]
		$.code[GoodsAssociation]
		$.name[Ассоциации товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsAssociationType[
		$.id[2111]
		$.code[GoodsAssociationType]
		$.name[Типы ассоциаций товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.CatalogFilter[
		$.id[2112]
		$.code[CatalogFilter]
		$.name[SEO фильтры]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsVariation[
		$.id[2113]
		$.code[GoodsVariation]
		$.name[Вариации товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsProperty[
		$.id[2114]
		$.code[GoodsProperty]
		$.name[Характеристики товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsPropertyPosibleValue[
		$.id[2115]
		$.code[GoodsPropertyPosibleValue]
		$.name[Возможные значения характеристик]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.Sku[
		$.id[2116]
		$.code[Sku]
		$.name[SKU]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.Brand[
		$.id[2117]
		$.code[Brand]
		$.name[Бренды]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsSerie[
		$.id[2118]
		$.code[GoodsSerie]
		$.name[Серии товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsSerieImage[
		$.id[2119]
		$.code[GoodsSerieImage]
		$.name[Изображения серий товаров]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.SeriesProperty[
		$.id[2120]
		$.code[SeriesProperty]
		$.name[Характеристики серий]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GoodsComplect[
		$.id[2121]
		$.code[GoodsComplect]
		$.name[Состав комплекта]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

^rem{ Гео  - 22**}

	$.GeoCity[
		$.id[2201]
		$.code[GeoCity]
		$.name[Гео: города]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GeoCountry[
		$.id[2202]
		$.code[GeoCountry]
		$.name[Гео: страны]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.GeoRegion[
		$.id[2203]
		$.code[GeoRegion]
		$.name[Гео: регионы]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.SiteRegion[
		$.id[2204]
		$.code[SiteRegion]
		$.name[Регионы]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

^rem{ Пользователи  - 23**}

	$.Session[
		$.id[2301]
		$.code[Session]
		$.name[Сессии]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.User[
		$.id[2302]
		$.code[User]
		$.name[Пользователи]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.UserGroup[
		$.id[2303]
		$.code[UserGroup]
		$.name[Группы пользователей]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.UserRole[
		$.id[2304]
		$.code[UserRole]
		$.name[Роли пользователей]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

^rem{ Интернет магазин  - 24**}

	$.AvailableDeliveries[
		$.id[2401]
		$.code[AvailableDeliveries]
		$.name[Зоны доставки]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.Order[
		$.id[2402]
		$.code[Order]
		$.name[Заказы]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.OrderStatus[
		$.id[2403]
		$.code[OrderStatus]
		$.name[Статусы заказов]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.DeliveryType[
		$.id[2404]
		$.code[DeliveryType]
		$.name[Способ доставки]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.PaymentType[
		$.id[2405]
		$.code[PaymentType]
		$.name[Способы оплаты]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

^rem{ Контент  - 25**}

	$.Object[
		$.id[2501]
		$.code[Object]
		$.name[Стуктура сайта]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.News[
		$.id[2502]
		$.code[News]
		$.name[Новости]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.Review[
		$.id[2503]
		$.code[Review]
		$.name[Отзывы]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.Post[
		$.id[2504]
		$.code[Post]
		$.name[Блог]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.SeoTextPatterns[
		$.id[2505]
		$.code[SeoTextPatterns]
		$.name[Seo-шаблоны]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.CatalogPage[
		$.id[2506]
		$.code[CatalogPage]
		$.name[Seo-тексты]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.Banner[
		$.id[2507]
		$.code[Banner]
		$.name[Баннеры]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

^rem{ Остальное  - 20**}

	$.Cache[
		$.id[2003]
		$.code[Cache]
		$.name[Кэш]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.Currency[
		$.id[2004]
		$.code[Currency]
		$.name[Валюты]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.Navigation[
		$.id[2005]
		$.code[Navigation]
		$.name[Навигация]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.Vendor[
		$.id[2305]
		$.code[Vendor]
		$.name[Каталог]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

	$.FeedbackTicket[
		$.id[3000]
		$.code[FeedbackTicket]
		$.name[Обращения]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]

^rem{ Рассылка  - 31**}

	$.MailingTemplate[
		$.id[3101]
		$.code[MailingTemplate]
		$.name[Шаблоны рассылки]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]	

	$.MailingCampaign[
		$.id[3102]
		$.code[MailingCampaign]
		$.name[Рассылки]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]		

	$.MailingGroup[
		$.id[3103]
		$.code[MailingGroup]
		$.name[Группы рассылок]

		$.rights[
			$.access[
				$.id[1]
				$.name[Доступ]
			]
		]
	]	
]]
