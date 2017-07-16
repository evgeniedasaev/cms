##############################################################################
#
##############################################################################

@CLASS
User

@OPTIONS
locals

@BASE
ObjectModel



##############################################################################
@auto[]
	$self.TYPES[^enum::create[
		$.person[
			$.id[0]
			$.name[Контакт]
			$.action_name[контакт]
			$.class_name[Person]
			$.icon[fa-user]
		]
		$.group[
			$.id[1]
			$.name[Отдел]
			$.action_name[отдел]
			$.class_name[Group]
			$.icon[fa-group]
		]
		$.company[
			$.id[3]
			$.name[Компания]
			$.action_name[компанию]
			$.class_name[Company]
			$.icon[fa-building]
		]

		$.guest[
			$.id[5]
			$.name[Аноним]
			$.action_name[анонима]
			$.class_name[Guest]
			$.icon[fa-user-secret]
		]
		$.role[
			$.id[6]
			$.name[Роль]
			$.action_name[роль]
			$.class_name[Role]
			$.icon[fa-user]
		]
	]]

	$self._table_name[user]

	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[type][
		$.type[string]
	]
	^field[uid][
		$.type[string]
		$.is_protected(true)
	]
	^field[name][
		$.type[string]
	]
	^field[email][
		$.type[string]
	]
	^field[new_email][
		$.type[string]
	]
	^field[passwd][
		$.type[string]
#		$.is_protected(true)
	]
	^field[new_passwd][
		$.type[string]
		$.is_protected(true)
	]
	^field[dt_register][
		$.type[datetime]
		$.is_protected(true)
	]
	^field[dt_update][
		$.type[datetime]
		$.is_protected(true)
	]
	^field[dt_logon][
		$.type[datetime]
		$.is_protected(true)
	]
	^field[dt_logout][
		$.type[datetime]
		$.is_protected(true)
	]
	^field[is_admin][
		$.type[bool]
		$.is_protected(true)
	]
	^field[is_published][
		$.type[bool]
#		$.is_protected(true)
	]
	^field[is_subscribed][
		$.type[bool]
	]
	^field[first_name][
		$.type[string]
	]
	^field[patronymic_name][
		$.type[string]
	]
	^field[last_name][
		$.type[string]
	]
	^field[title][
		$.type[string]
	]
	^field[position][
		$.type[string]
	]
	^field[company][
		$.type[string]
	]
	^field[phone][
		$.type[string]
	]
	^field[new_phone][
		$.type[string]
	]
	^field[phone_2][
		$.type[string]
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
	^field[birthday_day][
		$.type[int]
	]
	^field[birthday_month][
		$.type[int]
	]
	^field[birthday_year][
		$.type[int]
	]
	^field[info][
		$.type[string]
	]
	^field[avatar_file_name][
		$.type[string]
	]
	^field[discount][
		$.type[double]
	]
	^field[discount_type_id][
		$.type[int]
	]	
	^field[total_completed_order_price][
		$.type[double]
	]
	^field[total_completed_order_count][
		$.type[int]
	]
	^field[total_order_count][
		$.type[int]
	]

	^field_accessor[passwd_recover]
	^field_accessor[passwd_confirmation]
	^field_accessor[auth_tokean]

	^rem{ *** валидаторы *** }
	^validate_with[validate_name]
	^validates_uniqueness_of[name][
		$.scope[type]
	]
	^validates_format_of[name][
		$.width[^^[a-zа-я0-9_@\.\-\+\/]+^$]
		$.modificator[i]
	]
	^validates_length_of[name][
		$.minimum[3]
		$.maximum[64]
	]
	^validates_format_of[email][
		$.width[^^(?:[-a-z\d\+\*\/\?!{}`~_%&'=^^^$#]+(?:\.[-a-z\d\+\*\/\?!{}`~_%&'=^^^$#]+)*)@(?:[-a-z\d_]+\.){1,60}[a-z]{2,6}^$]
		$.modificator[i]
	]
	^validates_confirmation_of[passwd]
	^validates_file_of[avatar]
	^validates_image_of[avatar]
	^validates_numericality_of[phone][
		$.is_integer(true)
	]
	^validates_numericality_of[phone_2][
		$.is_integer(true)
	]	

	^rem{ *** ассоциации *** }
	^has_many[sessions][
		$.class_name[Session]
		$.order[dt_create DESC]
	]
	^has_many[orders][
		$.class_name[Order]
		$.foreign_key[user_id]
	]
	^has_one[actual_order][
		$.class_name[Order]
		$.foreign_key[user_id]
		$.condition[
			is_confirm = 0 AND
			object_status_id = $ObjectModel:OBJECT_STATUSES.active.id
		]
		$.order[dt_update DESC]
	]	
	^has_many[rights][
		$.class_name[UserRight]
	]
	^has_many[favorites][
		$.class_name[GoodsFavorite]
		$.foreign_key[user_id]

		$.dependent[destroy]

		$.order[dt_create DESC]
	]
	^has_and_belongs_to_many[mailing_groups][
		$.class_name[MailingGroup]
		$.join_table[mailing_group_to_user]
	]
	^has_many[user_subscriptions][
		$.class_name[MailingGroupToUser]
	]
	
	^has_many[social_logins][
		$.class_name[SocialLogin]
	]
	^has_many[twitter_logins][
		$.class_name[SocialLogin]
		$.condition[twitter_logins.type = "$SocialLogin:TYPES.tw.code"]
	]
	^has_many[facebook_logins][
		$.class_name[SocialLogin]
		$.condition[facebook_logins.type = "$SocialLogin:TYPES.fb.code"]
	]
	^has_many[vkontakte_logins][
		$.class_name[SocialLogin]
		$.condition[vkontakte_logins.type = "$SocialLogin:TYPES.vk.code"]
	]
	^has_many[yandex_logins][
		$.class_name[SocialLogin]
		$.condition[yandex_logins.type = "$SocialLogin:TYPES.ya.code"]
	]
	^has_many[odnoklassniki_logins][
		$.class_name[SocialLogin]
		$.condition[odnoklassniki_logins.type = "$SocialLogin:TYPES.ok.code"]
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
	^has_many[manger_orders][
		$.class_name[Order]
		$.foreign_key[auser_id]
	]		

	^rem{ *** файлы *** }
	^has_attached_image[avatar][
		$.is_deletable(true)

		$.small[
			$.0[
				$.action[resize]
				$.width[26]
				$.height[26]
				
				$.bKeepRatio(true)
				$.sResizeType[decr]

				$.iQuality(100)
			]
			$.1[
				$.action[crop]

				$.position[center]
			
				$.width[26]
				$.height[26]
				
				$.iQuality(100)
			]
		]
		$.normal[
			$.0[
				$.action[resize]
				$.width[50]
				$.height[50]

				$.bKeepRatio(true)
				$.sResizeType[decr]

				$.iQuality(100)
			]
		]
		$.big[
			$.0[
				$.action[resize]
				$.width[145]
				$.height[0]
				
				$.bKeepRatio(true)

				$.iQuality(100)
			]
			$.1[
				$.action[crop]

				$.position[center]
			
				$.width[145]
				$.height[145]
				
				$.iQuality(100)
			]
		]
	]

	^rem{ *** scopes *** }
	^scope[sorted][
		$.order[FIELD(user.type, "$User:TYPES.Company.class_name", "$User:TYPES.Group.class_name", "$User:TYPES.Person.class_name", "$User:TYPES.Guest.class_name") ASC]
	]
	^scope[only_users][
		$.condition[type IN ("$User:TYPES.Person.class_name")]
	]
	^scope[published][
		$.condition[is_published = 1]
	]
	
	^rem{ *** подключение дочерних моделей STI *** }
	^use[guest.p]
	^use[person.p]
	^use[employee.p]
	^use[company.p]
	^use[group.p]
	^use[role.p]
#end @auto[]



##############################################################################
@validate_name[]
	^if($self.is_published && !def $self.name){
		^self.errors.append[name_empty;name;Name empty]
	}
#end @validate_name[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.uid){
		$self.uid[^math:uuid[]]
	}

	^if(!def $self.dt_register){
		$self.dt_register[^date::now[]]
	}
#end @before_create[]



##############################################################################
@before_validate[]
	^BASE:before_validate[]

	$self.phone[^User:call_num_prepare[$self.phone]]
	$self.phone_2[^User:call_num_prepare[$self.phone_2]]
#end @before_validate[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]

	^if(def $self.passwd && $self.passwd ne $self.passwd_was && !$self.passwd_recover){
		$self.passwd[^cryptPassword[$self.passwd]]
	}

	^if(!def $self.passwd){
		$self.passwd[$self.passwd_was]
	}

	$self.title[^self.title.trim[]]

	$self.last_name[]
	$self.first_name[]
	$self.patronymic_name[]

	^if($self is Company){
		$self.company[$self.title]
		$self.first_name[$self.company]
	}
	^if($self is Person || $self is Guest){
		$title[^self.title.match[\s+][gi]{ }]
		$name_part[^title.split[ ]]
		$name_part[^name_part.hash{^name_part.offset[]}[piece][ $.type[string] ]]

		^if($name_part == 1){
			$self.first_name[$name_part.0]
		}{
			$self.last_name[$name_part.0]
			$self.first_name[$name_part.1]
			$self.patronymic_name[$name_part.2]
		}
	}
#end @before_save[]



##############################################################################
@generate_password[]
	$result[^for[i](0;5){^math:random(9)}]
#end of @generate_password[]



##############################################################################
@cryptPassword[sPassword]
	$result[^math:md5[$sPassword]]
#end @cryptPassword[]



###########################################################################
@isValidPassword[sPassword;sPasswordCrypted]
	^try{
		$result(
			def $sPassword
			&& def $sPasswordCrypted
			&& ^math:md5[$sPassword] eq $sPasswordCrypted
		)
	}{
		$exception.handled(true)
		$result(false)
	}
#end @isValidPassword[]




###########################################################################
@recoverPassword[bNotClearNewPasswdField]
	^rem{ *** выставляем флаг для отмены повторного криптирования *** }
	$self.passwd_recover(true)	

	$self.passwd[$self.new_passwd]
	$self.passwd_confirmation[$self.passwd]

	^rem{ *** сбрасываем пароль восстановления *** }
	^if(!$bNotClearNewPasswdField){
		$self.new_passwd[]			
	}
#end @recoverPassword[]



##############################################################################
#	Проверка авторизованности пользователя
##############################################################################
@GET_isGuest[]
	$result($self is Guest || !$self.is_published)
#end @GET_isGuest[]



##############################################################################
@GET_type[]
	$result[$self.CLASS.TYPES.[$self.attributes.type]]
#end @GET_type[]



##############################################################################
@GET_customer_title[]
	^throw_inspect[Не использовать getter customer_title. Вместо него использовать поле title.]
	$result[$self.title]
#end @GET_customer_title[]



##############################################################################
@GET_employee_title[]
	$result[$self.last_name $self.first_name]
#end @GET_employee_title[]



##############################################################################
@GET_geo_address[]
	$result[]

	^if($self.address_city){$result[$self.address_city.name]}
	^if($self.address_region){$result[${result}^if(def $result){, }$self.address_region.name]}
	^if($self.address_country){$result[${result}^if(def $result){, }$self.address_country.name]}
#end @GET_geo_address[]



##############################################################################
@merge[user]
	^rem{ *** sessions *** }
	^foreach[$user.sessions;session]{
		$session.user_id[$self.id]

		^if(!^session.save[]){
			^throw_inspect[^session.errors.array[]]
		}
	}

	^rem{ *** Группы *** }
	^foreach[$user.groups;group]{
		^self.groups.add[$group]
	}

	^rem{ *** Роли *** }
	^foreach[$user.roles;role]{
		^self.roles.add[$role]
	}

	^rem{ *** Права доступа *** }
	^foreach[$user.rights;right]{
		$right.user_id[$self.id]

		^if(!^right.save[]){
			^throw_inspect[^right.errors.array[]]
		}
	}

	^rem{ *** Заказ и позиции *** }
	^if($user.actual_order){
		$user.actual_order.object_status_id[$ObjectModel:OBJECT_STATUSES.draft.id]
		$user.actual_order.is_unvalidatable(true)

		^if(!^user.actual_order.save[]){
			^throw_inspect[^user.actual_order.errors.array[]]
		}

		^if(!$self.actual_order){
			$self.actual_order[^self.actual_order.build[
				$.is_confirm(false)
				$.object_status_id($ObjectModel:OBJECT_STATUSES.active.id)
				$.first_name[^if(def $self.first_name){$self.first_name}{$self.title}]
				$.last_name[$self.last_name]
				$.email[$self.email]
				$.company[$self.company]
				$.phone[$self.phone]
				$.address[$self.address]
				$.is_unvalidatable(true)
			]]		

			^if(!^self.actual_order.save[]){
				^throw_inspect[^self.actual_order.errors.array[]]
			}
		}{
			$self.actual_order.is_unvalidatable(true)
		}

		$cart[^array::create[]]
		^foreach[$user.actual_order.cart;item]{
			$copied_item[^OrderCart::create[]]
			
			^copied_item.update[$item]
			$copied_item.order_id[$self.actual_order.id]

			^cart.add[$copied_item]
		}

		^if($cart){
			^if(!^OrderCart:insert_all[$cart][
				$._amount[amount + VALUES(amount)]
			]){}
		}
	}

	^rem{*** копируем избранное ***}
	$favorites[^array::create[]]
	^foreach[$user.favorites;item]{
		^favorites.add[^self.favorites.build[
			$.goods_id[$item.goods_id]
			$.goods_name[$item.goods_name]
			$.dt_create[$item.dt_create]
		]]
	}

	^if($favorites){
		^if(!^GoodsFavorite:insert_all[$favorites][
			$._dt_create[dt_create]
		]){}
	}

	^if($self.dt_register < $user.dt_register){
		$self.dt_register[$user.dt_register]
	}
	^if(!def $self.info){
		$self.info[$user.info]
	}
	^if(!^self.save[]){
		^throw_inspect[^self.errors.array[]]
	}

	^rem{ *** TODO: Сохранять ID связи *** }
	$user.next_user_id[]

	^if(!^user.destroy[]){														^rem{ *** удаляем старый объект *** }
		^throw_inspect[^user.errors.array[]]
	}
#end @merge[]



##############################################################################
@GET_icon[]
	$result[$self.type.icon]
#end @GET_icon[]



##############################################################################
@SET_birthday[hData]
	$self.birthday_year[$hData.year]
	$self.birthday_month[$hData.month]
	$self.birthday_day[$hData.day]
#end @SET_birthday[]



##############################################################################
#	Возвращает User в виде json
##############################################################################
@static:json[key;user;options]
	$result[^json:string[
		$.id[$user.id]
		$.name[$user.title]
		$.first_name[$user.first_name]
		$.last_name[$user.last_name]
		$.middle_name[$user.middle_name]
		$.title[$user.title]
		$.phone[$user.phone]
		$.phone_2[$user.phone_2]
		$.email[$user.email]
		$.city[$user.city.name]
		$.address[$user.address]

		$.total_order_count[$user.total_order_count]
		$.total_completed_order_count[$user.total_completed_order_count]
		$.total_completed_order_price[$user.total_completed_order_price]

		$.card[
			$.code[$user.user_card.code]
			$.discount[$user.user_card.discount]
		]
	][$options]]
#end @static:json[]



##############################################################################
#	Метод приводит номер телефона к международному формату
##############################################################################
@call_num_prepare[sNum]
	$result[^sNum.match[\D][gi]{}]
	$result[^result.match[^^\+][i]{}]

	^if(^result.length[] < 5){
		$result[$result]														^rem{ *** игнорируем внутренние номера *** }
	}(^result.match[^^([78]10)]){
		$result[^result.mid(3)]
	}(^result.length[] >= 12){
		$result[$result]														^rem{ *** игнорируем длинные номера - разбираемся отдельно *** }
	}(^result.match[^^8(495|496|498|499)]){
		$result[7^result.mid(1)]												^rem{ *** если Московские телефоны без кода *** }
#	}(^result.match[^^8?(383|481|491|495|496|498|499|901|902|903|904|905|906|908|909|910|911|912|913|914|915|916|917|918|919|920|921|922|923|924|925|926|927|928|929|930|931|932|933|934|937|938|950|951|952|953|960|961|962|963|964|965|967|980|981|982|983|984|985|987|988)]){
#		$result[7^result.trim[left;8]]											^rem{ *** коды мобильных номеров без кода *** }
	}(^result.match[^^8]){
		$result[7^result.mid(1)]												^rem{ *** коды городов России *** }
	}(!^result.match[^^7]){
		$result[7$result]														^rem{ *** добавляем во все номера 7 по-умолчанию *** }
	}
#end @call_num_prepare[]



##############################################################################
#	Вывод номера телефона для звонка
##############################################################################
@print_phone[sPhone]
	$result[$sPhone]

	$result[^result.match[^[\s\(\)\+-^]][g]{}]
	^if(^result.match[^^8]){
		$result[7^result.mid(1)]												
	}(!^result.match[^^7]){
		$result[7${result}]														^rem{ *** добавляем во все номера 7 по-умолчанию *** }
	}

	$result[+${result}]
#end @print_phone[]



##############################################################################
#	Формирование логина для пользователя
##############################################################################
@define_name[]
	^if(def $self.email){
		$self.name[$self.email]
	}(def $self.phone){
		$self.name[^User:call_num_prepare[$self.phone]]
	}
#end @define_name[]



##############################################################################
# Перенос информации о гео в пользователя
##############################################################################
@fetch_data_from_city[oCity]
	^if($self.address_city_id != $oCity.id){
		$self.address_country[$oCity.country]
		$self.address_region[$oCity.region]
		$self.address_city[$oCity]

		^if(!^self.save[]){
			^throw_inspect[^self.errors.array[]]
		}
	}	
#end @fetch_data_from_city[]



##############################################################################
# Перенос информации о заказе в пользователя
##############################################################################
@fetch_data_from_order[oOrder]
	^if(!def $self.title){
		$self.title[$oOrder.user_name]
	}
	^if(!def $self.phone){
		$self.phone[$oOrder.phone]
	}
	^if(!def $self.phone_2){
		$self.phone_2[$oOrder.phone_2]
	}
	^if(!def $self.email && ^Lib:isEmail[$order.email]){
		$self.email[$oOrder.email]
	}
	^if(!def $self.address){
		$self.address[$oOrder.address]
		$self.subway[$oOrder.subway]
		$self.directions[$oOrder.directions]
	}
	
	^if(!^self.save[]){
		^throw_inspect[^self.errors.array[]]
	}
#end @fetch_data_from_order[]



##############################################################################
# Пересчитывает поля с данными по заказам
##############################################################################
@update_by_order[]
	$completed_orders[^self.orders.plug[
		$.column[
			$.qnt[COUNT(*)]
			$.total_price[SUM(orders.total)]
		]
		$.join[status]
		$.condition[status.base_status_id = $OrderStatus:BASE.done.id]
	]]

	^self.update[
		$.total_order_count(^self.orders.count[
			$.condition[is_confirm = 1]
		])
		$.total_completed_order_count[$completed_orders.qnt]
		$.total_completed_order_price[$completed_orders.total_price]
	]

	^if(!^self.save[]){
		^throw_inspect[^self.errors.array[]]
	}
#end @update_by_order[]
