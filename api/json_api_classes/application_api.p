##############################################################################
#
##############################################################################

@CLASS
ApplicationApi

@USE
json_api/json_api.p

@OPTIONS
locals

@BASE
JsonApi



##############################################################################
@create[hParams;sVersion]
    $self._api_params[^prepare_params[$hParams]]

    $self._version[$sVersion]
    
    $self._user[^User:find_by_id(^self._api_params.user_id.int(0))]
    $self._acl[^UserACL::create[$self._user]]
    
    $self._navigation[
        $.Content[
            $.name[Контент]
            $.icon[fa fa-newspaper-o fa-2x]

            $.items[
                $.Object[
                    $.name[Структура сайта]
                    $.link[
                        $.controller[object]
                    ]
                    $.access(^self._acl.check_rights[access;Object])
                ]

                $.News[
                    $.name[Новости]
                    $.link[
                        $.controller[news]
                    ]
                    $.access(^self._acl.check_rights[access;News])
                ]

                $.Blog[
                    $.name[Блог]
                    $.link[
                        $.controller[post]
                    ]
                    $.access(^self._acl.check_rights[access;Post])
                ]

                $.Banner[
                    $.name[Баннеры]
                    $.link[
                        $.controller[banner]
                    ]
                    $.access(^self._acl.check_rights[access;Banner])
                ]

                $.UserGenerated[
                    $.type[header]
                    $.name[Пользовательский]

                    $.items[

                        $.Review[
                            $.name[Отзывы]
                            $.link[
                                $.controller[review]
                            ]
                            $.access(^self._acl.check_rights[access;Review])
                        ]

                        $.Question[
                            $.name[Вопросы/Ответы]
                            $.link[
                                $.controller[question]
                            ]
                            $.access(^self._acl.check_rights[access;Question])
                        ]
                    ]
                ]

                $.Settings[
                    $.type[header]
                    $.name[Настройки]

                    $.items[
                        $.Navigation[
                            $.name[Навигаторы]
                            $.link[
                                $.controller[navigation]
                            ]
                            $.access(^self._acl.check_rights[access;Navigation])
                        ]
                    ]
                ]
            ]
        ]

        $.Catalog[
            $.name[Каталог]
            $.icon[fa fa-cube fa-2x]

            $.items[
                $.Goods[
                    $.name[Товары]
                    $.link[
                        $.controller[goods]
                    ]
                    $.access(^self._acl.check_rights[access;Goods])
                    
                    $.items[
                        $.GoodsVariation[
                            $.name[Варианты]
                            $.link[
                                $.controller[goods_variation]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsVariation])
                        ]
                        $.GoodsImage[
                            $.name[Изображения]
                            $.link[
                                $.controller[goods_image]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsImage])
                        ]
                        $.GoodsFile[
                            $.name[Файлы]
                            $.link[
                                $.controller[goods_file]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsFile])
                        ]
                        $.GoodsAssociation[
                            $.name[Файлы]
                            $.link[
                                $.controller[goods_association]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsAssociation])
                        ]
                        $.GoodsComplect[
                            $.name[Файлы]
                            $.link[
                                $.controller[complect_goods]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsComplect])
                        ]
                    ]
                ]

                $.Brand[
                    $.name[Бренды]
                    $.link[
                        $.controller[brand]
                    ]
                    $.access(^self._acl.check_rights[access;Brand])
                ]

                $.GoodsSerie[
                    $.name[Серии товаров]
                    $.link[
                        $.controller[goods_serie]
                    ]
                    $.access(^self._acl.check_rights[access;GoodsSerie])
                    
                    $.items[
                        $.GoodsSerieImage[
                            $.name[Изображения]
                            $.link[
                                $.controller[goods_serie_image]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsSerieImage])
                        ]
                    ]
                    
                ]

                $.CatalogSEO[
                    $.type[header]
                    $.name[SEO]

                    $.items[
                        $.CatalogPage[
                            $.name[SEO тексты]
                            $.link[
                                $.controller[catalog_page]
                            ]
                            $.access(^self._acl.check_rights[access;CatalogPage])
                        ]

                        $.SeoTextPatterns[
                            $.name[Шаблоны]
                            $.link[
                                $.controller[seo_text_patterns]
                            ]
                            $.access(^self._acl.check_rights[access;SeoTextPatterns])
                        ]

                        $.CatalogFilter[
                            $.name[Фильтры]
                            $.link[
                                $.controller[catalog_filter]
                            ]
                            $.access(^self._acl.check_rights[access;CatalogFilter])
                        ]
                    ]
                ]
                $.CatalogSettings[
                    $.type[header]
                    $.name[Настройки]

                    $.items[
                        $.GoodsType[
                            $.name[Типы товаров]
                            $.link[
                                $.controller[goods_type]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsType])
                        ]

                        $.GoodsFileType[
                            $.name[Типы файлов]
                            $.link[
                                $.controller[goods_file_type]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsFileType])
                        ]

                        $.GoodsAssociationType[
                            $.name[Типы ассоциаций]
                            $.link[
                                $.controller[goods_association_type]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsAssociationType])
                        ]
                    ]
                ]
                $.CatalogProperty[
                    $.type[header]
                    $.name[Характеристики]

                    $.items[
                        $.GoodsProperty[
                            $.name[Характеристики товаров]
                            $.link[
                                $.controller[goods_property]
                                $.action[goods]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsProperty])
                            
                            $.items[
                                $.GoodsPropertyActions[
                                    $.name[Создание/редактирование]
                                    $.link[
                                        $.controller[goods_property]
                                        $.entity_type[goods]
                                    ]
                                    $.access(^self._acl.check_rights[access;GoodsProperty])
                                ]

                                $.GoodsPropertyPosibleValue[
                                    $.name[Возможные значения]
                                    $.link[
                                        $.controller[goods_property_posible_value]
                                        $.entity_type[goods]
                                    ]
                                    $.access(^self._acl.check_rights[access;GoodsPropertyPosibleValue])
                                ]
                            ]
                        ]
                        $.SeriesProperty[
                            $.name[Характеристики серий]
                            $.link[
                                $.controller[goods_property]
                                $.action[series]
                            ]
                            $.access(^self._acl.check_rights[access;SeriesProperty])

                            $.items[
                                $.GoodsPropertyActions[
                                    $.name[Создание/редактирование]
                                    $.link[
                                        $.controller[goods_property]
                                        $.entity_type[series]
                                    ]
                                    $.access(^self._acl.check_rights[access;GoodsProperty])
                                ]

                                $.GoodsPropertyPosibleValue[
                                    $.name[Возможные значения характеристик]
                                    $.link[
                                        $.controller[goods_property_posible_value]
                                        $.entity_type[series]
                                    ]
                                    $.access(^self._acl.check_rights[access;GoodsPropertyPosibleValue])
                                ]
                            ]
                        ]
                    ]
                ]

                $.CatalogColor[
                    $.type[header]
                    $.name[Цвета]

                    $.items[
                        $.GoodsBaseColor[
                            $.name[Базовые цвета]
                            $.link[
                                $.controller[goods_base_color]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsBaseColor])
                        ]

                        $.GoodsColor[
                            $.name[Цвета]
                            $.link[
                                $.controller[goods_color]
                            ]
                            $.access(^self._acl.check_rights[access;GoodsColor])
                        ]
                    ]
                ]
            ]
        ]

        $.Shop[
            $.name[Интернет-магазин]
            $.icon[fa fa-shopping-cart fa-2x]

            $.items[
                $.Sales[
                    $.type[header]
                    $.name[Продажи]

                    $.items[
                        $.Order[
                            $.name[Заказы]
                            $.link[
                                $.controller[order]
                            ]
                            $.access(^self._acl.check_rights[access;Order])
                        ]
                        $.Customers[
                            $.name[Покупатели]
                            $.link[
                                $.controller[customer]
                            ]
                            $.access(^self._acl.check_rights[access;User])
                        ]
                    ]
                ]

                $.ShopSettings[
                    $.type[header]
                    $.name[Настройки]

                    $.items[
                        $.OrderStatus[
                            $.name[Статусы заказов]
                            $.link[
                                $.controller[order_status]
                            ]
                            $.access(^self._acl.check_rights[access;OrderStatus])
                        ]

                        $.DeliveryType[
                            $.name[Способы доставки]
                            $.link[
                                $.controller[delivery_type]
                            ]
                            $.access(^self._acl.check_rights[access;DeliveryType])
                        ]

                        $.PaymentType[
                            $.name[Способы оплаты]
                            $.link[
                                $.controller[payment_type]
                            ]
                            $.access(^self._acl.check_rights[access;PaymentType])
                        ]
                    ]
                ]
                $.ShopReports[
                    $.type[header]
                    $.name[Отчеты]

                    $.items[
                        $.ReportOrders[
                            $.name[Отчет по заказам]
                            $.link[
                                $.controller[report_orders]
                            ]
                            $.access(^self._acl.check_rights[access;ReportOrders])
                        ]

                        $.ReportSales[
                            $.name[Отчет по продажам]
                            $.link[
                                $.controller[report_sales]
                            ]
                            $.access(^self._acl.check_rights[access;ReportSales])
                        ]
                    ]
                ]
            ]
        ]

        $.Storage[
            $.name[Склад]
            $.icon[fa fa-cubes fa-2x]

            $.items[
                $.Remains[
                    $.type[header]
                    $.name[Остатки]

                    $.items[
                        $.SKU[
                            $.name[SKU]
                            $.link[
                                $.controller[sku]
                            ]
                            $.access(^self._acl.check_rights[access;Sku])
                        ]
                    ]
                ]

                $.StorageTurnover[
                    $.type[header]
                    $.name[Товарооборот]

                    $.items[
                        $.Supply[
                            $.name[Приемки]
                            $.link[
                                $.controller[supply]
                            ]
                            $.access(^self._acl.check_rights[access;Supply])
                        ]

                        $.Demand[
                            $.name[Отгрузки]
                            $.link[
                                $.controller[demand]
                            ]
                            $.access(^self._acl.check_rights[access;Demand])
                        ]

                        $.Inventory[
                            $.name[Инвентаризация]
                            $.link[
                                $.controller[inventory]
                            ]
                            $.access(^self._acl.check_rights[access;Inventory])
                        ]
                    ]
                ]
                $.StorageSettings[
                    $.type[header]
                    $.name[Настройки]

                    $.items[
                        $.Storages[
                            $.name[Склады]
                            $.link[
                                $.controller[warehouse]
                            ]
                            $.access(^self._acl.check_rights[access;Warehouse])
                        ]

                        $.Vendor[
                            $.name[Поставщики]
                            $.link[
                                $.controller[vendor]
                            ]
                            $.access(^self._acl.check_rights[access;Vendor])
                        ]

                        $.Price[
                            $.name[Прайс-листы]
                            $.link[
                                $.controller[price]
                            ]
                            $.access(^self._acl.check_rights[access;Price])
                        ]
                    ]
                ]
            ]
        ]

        $.Client[
            $.name[Контакты]
            $.icon[fa fa-users fa-2x]
            $.link[
                $.controller[client]
            ]
            $.access(^self._acl.check_rights[access;Client])
        ]

        $.FeedbackTicket[
            $.name[Обращения]
            $.icon[fa fa-inbox fa-2x]
            $.link[
                $.controller[feedback_ticket]
            ]
            $.access(^self._acl.check_rights[access;FeedbackTicket])
        ]

        $.Mailings[
            $.name[Рассылки]
            $.icon[fa fa-envelope fa-2x]
            $.items[
                $.Layout[
                    $.name[Шаблоны рассылки]
                    $.link[
                        $.controller[mailing_template]
                    ]
                    $.access(true)
                ]
                
                $.Template[
                    $.name[Рассылки]
                    $.link[
                        $.controller[mailing_campaign]
                    ]
                    $.access(true)
                ]	
                
                $.Group[
                    $.name[Группы рассылок]
                    $.link[
                        $.controller[mailing_group]
                    ]
                    $.access(true)
                ]		
            ]
        ]

        $.Statistics[
            $.name[Статистика]
            $.icon[fa fa-area-chart fa-2x]
            $.link[
                $.controller[statistics]
            ]
            $.access(^self._acl.check_rights[access;Statistics])
        ]

        $.Automation[
            $.name[Автомаизация]
            $.title[Автомаизация / Инструменты]
            $.icon[fa fa-magic fa-2x]

            $.items[
                $.YandexMarket[
                    $.name[Яндекс.Маркет]
                    $.link[
                        $.controller[yandex_market]
                    ]
                    $.access(^self._acl.check_rights[access;YandexMarket])
                ]

                $.GoodsPriceRecounting[
                    $.name[Пересчет цен]
                    $.link[
                        $.controller[goods_price_recounting]
                    ]
                    $.access(^self._acl.check_rights[access;GoodsPriceRecounting])
                ]
            ]
        ]

        $.Settings[
            $.name[Настройки]
            $.icon[fa fa-gear fa-2x]

            $.items[
                $.Cache[
                    $.name[Сбросить кэш]
                    $.link[
                        $.controller[cache]
                        $.action[clean]
                    ]
                    $.access(^self._acl.check_rights[access;Cache])
                ]
                $.Currency[
                    $.name[Валюты]
                    $.link[
                        $.controller[currency]
                    ]
                    $.access(^self._acl.check_rights[access;Currency])
                ]

                $.Geo[
                    $.type[header]
                    $.name[Гео]

                    $.items[

                        $.GeoCountry[
                            $.name[Страны]
                            $.link[
                                $.controller[geo_country]
                            ]
                            $.access(^self._acl.check_rights[access;GeoCountry])
                        ]

                        $.GeoRegion[
                            $.name[Регионы]
                            $.link[
                                $.controller[geo_region]
                            ]
                            $.access(^self._acl.check_rights[access;GeoRegion])
                        ]

                        $.GeoCity[
                            $.name[Города]
                            $.link[
                                $.controller[geo_city]
                            ]
                            $.access(^self._acl.check_rights[access;GeoCity])
                        ]

                        $.SiteRegion[
                            $.name[Гео-локации]
                            $.link[
                                $.controller[site_region]
                            ]
                            $.access(^self._acl.check_rights[access;SiteRegion])
                        ]
                    ]
                ]
                $.UserHeader[
                    $.type[header]
                    $.name[Пользователи]

                    $.items[
                        $.Employees[
                            $.name[Сотрудники]
                            $.link[
                                $.controller[user]
                            ]
                            $.access(^self._acl.check_rights[access;User])
                        ]

                        $.UserGroups[
                            $.name[Группы пользователей]
                            $.link[
                                $.controller[user_group]
                            ]
                            $.access(^self._acl.check_rights[access;UserGroup])
                        ]

                        $.UserRoles[
                            $.name[Роли]
                            $.link[
                                $.controller[user_role]
                            ]
                            $.access(^self._acl.check_rights[access;UserRole])
                        ]
                    ]
                ]
            ]
        ]
    ]
#end @create[]



##############################################################################
@fetch_list[]
    $result[
        $.data[
            $.title[CMS 3.0]
            $.logo[/admin/css/print/logo_for_blank.png]
            $.navigation[^handle_navigation[$self._navigation]]
        ]
        $.jsonapi[
            $.version[$self._version]
        ]
    ]
#end @fetch_list[]




##############################################################################
@handle_navigation[hNavigations]
    $result[^array::create[]]
    
    $i(0)
    ^hNavigations.foreach[code;navigation]{
        ^result.add[^handle_navigation_item[$navigation;$code;$i]]
        ^i.inc[]
    }
#end @handle_navigation[]




##############################################################################
@handle_navigation_item[hNavItem;sCode;iId]
    $result[^hash::create[]]

    $result[$hNavItem]
    $result.id($iId)
    $result.code[$sCode]

    ^if($result.items){
        $result.items[^handle_navigation[$result.items]]
    }
#end @handle_navigation_item[]

