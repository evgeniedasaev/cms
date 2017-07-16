##############################################################################
#
##############################################################################

@CLASS
Order

@OPTIONS
locals

@BASE
ObjectModel



##############################################################################
@auto[]
	^BASE:auto[]

	$self.ORDER_PAYMENT_STATUSES[
		$.0[
			$.name[Не оплачен]
			$.color[black]
		]
		$.1[
			$.name[Оплачен]
			$.color[#00CC00]
		]
		$.2[
			$.name[Ожидает оплаты]
			$.color[#0099ff]
		]
		$.3[
			$.name[Ожидает подтверждения оплаты]
			$.color[#00cc99]
		]
	]

	$self.ORDER_PAYMENT_STATUSES_BY_CODE[
		$.payment_pending[2]
		$.payment_confirmation_pending[3]
	]

	$self.ORDER_REFERER[
		$.0[
			$.id(0)
			$.code[site]
			$.name[Заказ с сайта]
		]
		$.1[
			$.id(1)
			$.code[manager]
			$.name[Создан менеджером]
		]
	]

	^rem{ *** аттрибуты *** }
	^field[code][
		$.type[string]
	]
	^field[uid][
		$.name[order_uuid]
		$.type[string]
	]
	^field[dt_delivery][
		$.type[date]
	]
	^field[dt_delivery_time_string][
		$.type[string]
	]
	^field[dt_delivery_time_from][
		$.type[string]
	]
	^field[dt_delivery_time_to][
		$.type[string]
	]
	^field[delivery_id][
		$.type[int]
	]
	^field[delivery_type][
		$.type[string]
	]
	^field[delivery_interval][
		$.type[string]
	]
	^field[delivery_distance][
		$.type[int]
	]
	^field[payment_id][
		$.type[int]
	]
	^field[user_id][
		$.type[int]
	]
	^field[user_card_code][
		$.type[string]
	]
	^field[user_card_total][
		$.type[string]
	]
	^field[delivery_name][
		$.type[string]
	]
	^field[delivery_price_cur][
		$.type[double]
	]
	^field[delivery_price_cur_id][
		$.type[double]
	]
	^field[is_with_loader][
		$.type[int]
	]
	^field[is_confirm][
		$.type[int]
	]
	^field[status_id][
		$.type[int]
	]
	^field[is_success][
		$.type[bool]
	]
	^field[payment_status_id][
		$.type[int]
	]
	^field[user_name][
		$.name[first_name]
		$.type[string]
	]
	^field[company][
		$.type[string]
	]
	^field[phone][
		$.type[string]
	]
	^field[phone_2][
		$.type[string]
	]
	^field[email][
		$.type[string]
	]
	^field[delivery_address_id][
		$.type[int]
	]
	^field[transport_company_id][
		$.type[int]
	]
	^field[user_address_id][
		$.type[int]
	]
	^field[address_country_id][
		$.type[int]
	]
	^field[address_region_id][
		$.type[int]
	]
	^field[address_city_id][
		$.type[int]
	]
	^field[subway][
		$.type[string]
	]
	^field[directions][
		$.type[string]
	]
	^field[address][
		$.type[string]
	]
	^field[comment][
		$.type[string]
	]
	^field[total][
		$.type[double]
	]
	^field[auser_id][
		$.type[int]
	]
	^field[auser_comment][
		$.type[text]
	]
	^field[dt][
		$.type[date]
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
	^field[discount][
		$.type[double]
	]
	^field[discount_type_id][
		$.type[int]
	]

	^rem{ *** физ лицо / юр лицо *** }
	^field[business_entity][
		$.type[int]
	]
	^field[postalcode][
		$.type[string]
	]
	^field[legal_address][
		$.type[string]
	]
	^field[INN][
		$.type[string]
	]
	^field[KPP][
		$.type[string]
	]
	^field[BIK][
		$.type[string]
	]
	^rem{ *** Корреспондентский счет *** }
	^field[corr_account][
		$.type[string]
	]
	^rem{ *** расчетный счет *** }
	^field[giro_account][
		$.type[string]
	]
	^field[order_referer][
		$.type[int]
	]

	^rem{ *** TODO: сумма заказа в итоговом поле *** }
	
	^rem{ *** ассесоры *** }
	^field_accessor[fio]
	^field_accessor[is_unvalidatable]

	^rem{ *** валидаторы *** }
	^validates_presence_of[user_id]
	^validates_numericality_of[user_id]
	^validate_with[validate_everything]
	^validates_numericality_of[phone][
		$.is_integer(true)
	]
	^validates_numericality_of[phone_2][
		$.is_integer(true)
	]

	^rem{ *** связи *** }
	^belongs_to[auser][
		$.class_name[User]
		$.foreign_key[auser_id]
	]
	^belongs_to[address_country][
		$.class_name[GeoCountry]
		$.foreign_key[address_country_id]
	]
	^belongs_to[address_region][
		$.class_name[GeoRegion]
		$.foreign_key[address_region_id]
	]
	^belongs_to[address_city][
		$.class_name[GeoCity]
		$.foreign_key[address_city_id]		
	]
# 	^belongs_to[transport_company][
# 		$.class_name[TransportCompany]
# 	]
	^belongs_to[delivery][
		$.class_name[DeliveryType]
		$.foreign_key[delivery_id]
	]
	^belongs_to[payment][
		$.class_name[PaymentType]
		$.foreign_key[payment_id]
	]
	^belongs_to[user][
		$.touch[update_by_order]
	]
	^belongs_to[status][
		$.class_name[OrderStatus]
		$.foreign_key[status_id]
	]
	^has_many[cart][
		$.class_name[OrderCart]
		$.dependent[destroy]
		
		$.order[order_cart_id ASC]
	]
	^has_many[bills][
		$.class_name[Bill]
		$.order[dt DESC]
	]

	^scope[sorted][
		$.order[dt DESC]
	]
	^scope[confirmed][
		$.condition[
			is_confirm = 1 AND
			object_status_id = $ObjectModel:OBJECT_STATUSES.active.id
		]
	]
#end @auto[]



##############################################################################
@before_validate[]
	^BASE:before_validate[]

	$self.phone[^User:call_num_prepare[$self.phone]]
	$self.phone_2[^User:call_num_prepare[$self.phone_2]]

	$self.email[^self.email.trim[]]
#end @before_validate[]



##############################################################################
@validate_everything[hParams]
	^if(!$self.is_unvalidatable){
		^if(!def $self.first_name && !def $self.last_name && !def $self.user_name){
			^self.errors.append[name_empty;first_name, last_name;Name empty]
		}
		
		^self._validates_presence_of[
			$.attribute[phone]
		]

		^self._validates_format_of[
			$.attribute[email]
			$.width[^^(?:[-a-z\d\+\*\/\?!{}`~_%&'=^^^$#]+(?:\.[-a-z\d\+\*\/\?!{}`~_%&'=^^^$#]+)*)@(?:[-a-z\d_]+\.){1,60}[a-z]{2,6}^$]
			$.modificator[i]
		]
	}

	^if($self.delivery_id && $self.delivery.is_address_required){
		^self._validates_presence_of[
			$.attribute[address]
		]
	}	
#end @validate_first_name_and_phone[]



##############################################################################
@GET_city[]
	$result[$self.address_city]
#end @GET_city[]



##############################################################################
@GET_fio[]
	$result[$self.last_name $self.first_name $self.middle_name]
	$result[^result.trim[]]
#end @GET_fio



##############################################################################
@SET_fio[sName]
	$tSpace[^sName.match[(\s)][']]
	^if($tSpace){
		$tName[^sName.split[$tSpace.match;h]]
		$self.last_name[$tName.0]
		$self.first_name[$tName.1]
		$self.middle_name[$tName.2]
	}{
		$self.first_name[$sName]
	}
#end @SET_fio



##############################################################################
@GET_city_name[]
	$result[$self.city.name]
#end @GET_city_name



##############################################################################
@GET_full_address[]
	$result[$self.city_name^if(def $self.address){, $self.address}]
#end @GET_full_address[]



##############################################################################
@GET_full_legal_address[]
	$result[$self.postalcode^if(def $self.legal_address){, $self.legal_address}]
#end @GET_full_legal_address[]



##############################################################################
@GET_tax[]
	$result(0)
#end @GET_tax[]



##############################################################################
@GET_customer_title[]
	^switch($self.business_entity){
		^case(1){
			$result[$self.company]
		}
		^case[DEFAULT]{
			$result[$self.last_name $self.first_name]
			$result[^result.trim[]]
		}
	}

	^if(!def $result){
		$result[$self.user_name]
	}

	^if(!def $result){
		$result[Без имени]
	}
#end @GET_customer_title[]



##############################################################################
@GET_contact_name[]
	$result[$self.last_name $self.first_name]
	$result[^result.trim[]]

	^if(!def $result){
		$result[Без имени]
	}
#end @GET_contact_name[]



##############################################################################
#	Стоимость всех товаров из заказа
##############################################################################
@GET_total_cart_price[]
	$result(0)

	^rem{ *** вычисляем сумму всех товаров *** }
	^foreach[$self.cart;goods]{
		^result.inc($goods.total)
	}
#end @GET_total_cart_price[]



##############################################################################
#	Стоимость всех товаров из заказа без скидок
##############################################################################
@GET_total_cart_price_without_discount[]
	$result(0)

	^rem{ *** вычисляем сумму всех товаров *** }
	^foreach[$self.cart;goods]{
		^result.inc($goods.total_without_discount)
	}
#end @GET_total_cart_price_without_discount[]



##############################################################################
#	Коммисия платежной системы (в рублях)
##############################################################################
@GET_payment_commision_price[]
	^if($self.payment.commission){
		$result($self.total * (1 + $self.payment.commission / 100))
	}{
		$result(0)
	}
#end @GET_payment_commision_price[]



##############################################################################
#	Курс для стоимости доставки
##############################################################################
@GET_delivery_price_currency[]
	^if($self.delivery_price_cur_id){
		$result[$Currency:all.[$self.delivery_price_cur_id]]
	}{
		$result[$Currency:base]
	}
#end @GET_delivery_price_currency[]



##############################################################################
#	Стоимость доставки в базовой валюте
##############################################################################
@GET_delivery_price[]
	$result($self.delivery_price_cur * $self.delivery_price_currency.rate)
#end @GET_delivery_price[]



##############################################################################
#	Заказ оплачен на сумму
##############################################################################
@GET_paid_for[]
	$result(0)
	
	^foreach[$self.bills;bill]{
		^if($bill.status_id == 0){^continue[]}
		
		^result.inc($bill.price)
	}
#end @GET_paid_for[]



##############################################################################
#	Счиатем заказ оплаченым, если по нему приход больше суммы заказа
#	или стоит статус, что он оплачен
##############################################################################
@GET_is_fully_paid[]
	$result($self.payment_status_id == 1 || $self.total <= $self.paid_for)
#end @GET_is_fully_paid[]



##############################################################################
@GET_total_amount[]
	$result(0)

	^foreach[$self.cart;goods]{
		^result.inc($goods.amount)
	}
#end @GET_total_amount[]



##############################################################################
#	Установить delivery_distance
##############################################################################
@SET_delivery_distances[hDistances]
	^if($self.delivery_id && def $hDistances.[$self.delivery_id]){
		$self.delivery_distance[$hDistances.[$self.delivery_id]]
	}
#end @SET_delivery_distances[]



##############################################################################
@GET_payment_status[]
	$result[$Order:ORDER_PAYMENT_STATUSES.[$self.payment_status_id]]
#end @GET_payment_status[]



##############################################################################
@before_create[]
	^BASE:before_create[]
	
	$self.uid[^math:uuid[]]
	
	^if(!def $self.dt_create){
		$self.dt_create[^date::now[]]
	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]
	
	$self.dt_update[^date::now[]]
	
	^rem{ *** стандартный статус *** }
	^if(!$self.status_id){
		$self.status_id[$OrderStatus:NEW.id]
	}

	^if($self.delivery){
		$self.delivery_name[$self.delivery.name]
		$self.delivery_price_cur_id[$self.delivery.price_cur_id]		

		^if($self.delivery_distance){
			$self.delivery_name[$self.delivery.name ($self.delivery_distance км)]
		}

		^rem{ *** определяем цену доставки, если она не задана *** }
		^if(!^self.delivery_price_cur.int(0)){
			$self.delivery_price_cur[$self.delivery.price_cur]
			$self.delivery_price_cur_id[$self.delivery.price_cur_id]
		}

		^rem{ *** если выбрана доставка с указанием времени, но дата или время не передано *** }
		^if($self.delivery.is_timed && (!def $self.dt_delivery || !def $self.dt_delivery_time_from || !def $self.dt_delivery_time_to || !def $self.dt_delivery_time_string)){
			^rem{ *** придумать и сделать что-то *** }
		}
	}{
		^rem{ *** если доставка не выбрана - очищаем данные по доставке *** }
		$self.delivery_name[$NULL]
		$self.delivery_price_cur[$NULL]
		$self.delivery_price_cur_id[$NULL]
	}

	^if($self.address_city){
		$self.address_country[$self.address_city.country]
		$self.address_region[$self.address_city.region]
	}
#end @before_save[]



##############################################################################
@after_save[]
	^BASE:after_save[]
	
	^rem{ *** при изменении статуса заказа вычисляем его code *** }
	^rem{ *** заказы без code не являются подтвержденными *** }
	^if(!def $self.code && $self.is_confirm != $self.is_confirm_was){
		^if($self.is_confirm){
#			$seq_num[^Order:count[
#				$.condition[
#					is_confirm = 1 AND
#					dt_create >= "^dtf:format[%Y-%m-%d 00:00:00][$self.dt_create]" AND
#					dt_create <= "^dtf:format[%Y-%m-%d 23:55:59][$self.dt_create]"
#				]
#			]]
#	
#			$self.code[${self.id}-^dtf:format[%m%d][$self.dt_create]^eval($seq_num)[%02d]]
			$self.code[${self.id}]
		}{
			$self.code[]
		}
	}
	
	^if(!^self.save[]){
		^throw_inpect[^self.errors.array[]]
	}

	^if($self.user_id != $self.user_id_was){
		$user_was[^User:find_by_id($self.user_id_was)]
		^if($user_was){
			^user_was.update_by_order[]
		}
	}
	
	^if($self.user){
		^self.user.fetch_data_from_order[$self]
	}
#end @after_save[]



##############################################################################
@after_update[]
	^BASE:after_update[]
	
	^rem{ *** если изменился статус заказа *** }
	^if($self.status_id != $self.status_id_was){
		$status[^OrderStatus:find_by_id($self.status_id)]
		$status_was[^OrderStatus:find_by_id($self.status_id_was)]
		
		^rem{ *** если изменился базовый статус *** }
		^if($status.base_status_id != $status_was.base_status_id){
			^rem{ *** предыдущий статус *** }
			^switch($status_was.base_status_id){
				^case($OrderStatus:BASE.done.id){
					^rem{ *** перенесен из выполненных заказов *** }
					
					^rem{ *** вернуть товары на склад *** }
				}
			}
			
			^rem{ *** новый статус *** }
			^switch($status.base_status_id){
				^case($OrderStatus:BASE.done.id){
					^rem{ *** перенесен в выполненные заказы *** }
					
					^rem{ *** списать товары со склада *** }
				}
				^case($OrderStatus:BASE.cancel.id){
					^rem{ *** перенесен в отмененные заказы *** }
					
					^rem{ *** снять резерв *** }
				}
			}
		}
		
		^rem{ *** обнолуяем возвраты на товары *** }
		^foreach[$self.cart;item]{
			^item.undo_reserve[]
		}
	}

	^rem{ *** если заказ выполнен успешно *** }
	^if($self.is_success && $self.is_success != $self.is_success_was && def $self.email){
		^OrderReviewMail:send[
			$.to[$self.email]
			$.order[$self]
		]
	}
#end @after_update[]



##############################################################################
@GET_code[]
	$result[^if(def $self.attributes.code){$self.attributes.code}{$self.id}]
#end @GET_code[]



##############################################################################
@GET_total_wo_commission[]
	$result($self.total_cart_price)

	^rem{ *** добавляем стоимость доставки *** }
	^result.inc($self.delivery_price)
#end of @GET_total_wo_commision



##############################################################################
@GET_referer_info[]
	$result[$self.ORDER_REFERER.[$self.order_referer]]
#end of @GET_referer_info[]



##############################################################################
@available_deliveries[]
	$result[^Delivery:find[
		$.include[available_deliveries]
		$.join[
			$.available_deliveries[
				$.condition[
					available_deliveries.city_id IN (0^if($self.city.city_id){,$self.city.city_id}) AND
					available_deliveries.region_id IN (0^if($self.city.region_id){,$self.city.region_id}) AND
					available_deliveries.country_id IN (0^if($self.city.country_id){,$self.city.country_id})
				]
			]
			$.customer_types[
				$.condition[customer_types.user_customer_type_id = $self.user.customer_type_id]
			]
		]
		$.order[sort_order]
	]]
#end @available_deliveries[]



##############################################################################
@available_payments[]
	$result[^self.delivery.payments.find[
		$.join[
			$.customer_types[
				$.condition[customer_types.user_customer_type_id = $self.user.customer_type_id]
			]
		]
		$.condition[is_published = 1]
	]]
#end @available_payments[]



##############################################################################
@GET_total_without_discount[]
	$result($self.total_cart_price_without_discount)

	^rem{ *** добавляем стоимость доставки *** }
	^result.inc($self.delivery_price)
	
	^rem{ *** добавляем коммисию платежной системы *** }
	^if($self.payment.commission){
		$result($result * (1 + $self.payment.commission / 100))
	}
	
	$result[^eval($result)[%.2f]]
#end @GET_total_without_discount[]



##############################################################################
@GET_total_saving[]
	$result($self.total_without_discount - ^self.calculate_total[])
#end @GET_total_saving[]



##############################################################################
@GET_total_discount[]
	$result(^math:round($self.total_saving / ^if($self.total_without_discount){$self.total_without_discount}{1} * 100))
#end @GET_total_discount[]



##############################################################################
@calculate_total[]
	$result($self.total_wo_commission)
	
	^rem{ *** добавляем коммисию платежной системы *** }
	^if($self.payment.commission){
		$result($result * (1 + $self.payment.commission / 100))
	}
	
	$result[^eval($result)[%.2f]]
#end @calculate_total[]



##############################################################################
@GET_user_card_discount_percent[]
	$result(0)

	^CARD_DISCOUNTS.foreach[sum;discount]{
		^if($self.total_cart_price_without_discount + $self.user_card_total >= $sum){
			$result($discount)													^rem{ *** вычисляем накопительную скидку по товарам *** }
		}
	}

	^if($self.user_card.discount > $result){
		$result($self.user_card.discount)										^rem{ *** проверяем текущую скидку по карте *** }
	}
#end @GET_user_card_discount_percent[]



##############################################################################
#	Метод вычисляет скидки по товарам в зависимости от 
##############################################################################
@calculate_cart_user_card_discount[]
	$discount($self.user_card_discount_percent)
	
	$self.discount($discount)
	$self.discount_type_id(0)													^rem{ *** скидка - процент *** }
	
#	^foreach[$self.cart;order_item]{
#		$normalized_min_price(^CARD_DISCOUNT_MIN_PRICES.[$order_item.goods.type_id].int(0) * $order_item.goods.volume / 0.5)
#		$price($order_item.price - $order_item.price * $discount / 100)
#
#		^order_item.update[
#			^if($price < $normalized_min_price){
#				$.price_discount($order_item.price - $normalized_min_price)
#				$.price_discount_type_id($Currency:base.id)
#			}{
#				$.price_discount($discount)
#				$.price_discount_type_id(0)
#			}
#		]
#	}
#end @calculate_cart_user_card_discount[]



##############################################################################
@recalculate_total[bSave]
# 	^self.calculate_cart_user_card_discount[]								^rem{ *** перераспределяем скидку по товарам *** }
	
	$self.total[^self.calculate_total[]]

	^if(^bSave.bool(true)){
		^if(!^self.save[]){
			^throw_inspect[^self.errors.array[]]
		}
	}
#end @recalculate_total[]



##############################################################################
@prepare_for_api[]
    $result[^hash::create[$self.attributes]]

	$result.order_link[/_admin/order/view/$self.id/]
    ^if($self.user){
        $result.customer_link[/_admin/customer/edit/$self.user.id/]
    }
	$result.auser_assign[/_admin/customer/assign_manager/$self.id/]
	$result.dt_human[$self.dt]
	$result.dt_create_human[$self.dt_create]
	$result.dt_update_human[$self.dt_update]
	$result.customer_title[$self.customer_title]
	$result.paid_for($self.paid_for)
	$result.total($self.total)
#end @prepare_for_api[]