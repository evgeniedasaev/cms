##############################################################################
#	
##############################################################################

@CLASS
FeedbackTicket

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	$self.STATUSES[
		$.0[
			$.name[Новая]
			$.class[alert-error]
		]
		$.1[
			$.name[Выполнена]
			$.class[alert-success]
		]
		$.2[
			$.name[Не удалось связаться]
			$.class[warning]
		]
		$.3[
			$.name[Отменена]
			$.class[gray]
		]
	]

	^rem{*** поля ***}
	^field[status_id][
		$.type[int]
	]
	^field[user_id][
		$.type[type]
	]
	^field[user_name][
		$.type[string]
	]
	^field[email][
		$.type[string]
	]
	^field[phone][
		$.type[string]
	]
	^field[title][
		$.type[string]
	]
	^field[comment][
		$.type[string]
	]
	^field[order_n][
		$.type[int]
	]
	^field[ip][
		$.type[string]
	]
	^rem{*** последний сотрудник, обрабатывающий обращение ***}
	^field[manager_id][
		$.type[string]
	]
	^field[dt_create][
		$.type[date]
	]
	^field[dt_update][
		$.type[date]
	]

	^rem{ *** ассесоры *** }
	^field_accessor[publish_manager]

	^rem{ *** валидаторы *** }
	^validates_presence_of[user_name]
	^validates_presence_of[title]
	^validate_with[validate_user_contact]
	^validates_format_of[email][
		$.width[^^(?:[-a-z\d\+\*\/\?!{}`~_%&'=^^^$#]+(?:\.[-a-z\d\+\*\/\?!{}`~_%&'=^^^$#]+)*)@(?:[-a-z\d_]+\.){1,60}[a-z]{2,6}^$]
		$.modificator[i]
	]

	^rem{ *** ассоциации *** }
	^belongs_to[user]

	^scope[published][
		$.condition[is_published = 1]
	]
	^scope[sorted][
		$.order[dt DESC]
	]	
#end @auto[]



##############################################################################
@validate_user_contact[hParams]
	^if(!def $self.email && !def $self.phone){
		^self.errors.append[contact_empty;contact_fields;contact empty]
	}
#end @validate_user_contact[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.dt_create){
		$self.dt_create[^date::now[]]
	}

	^self.save_ip[]
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]

	^self.save_manager[]
#end @before_save[]



##############################################################################
@save_ip[]
	$self.ip[$env:REMOTE_ADDR^if(def $env:HTTP_X_REAL_IP){, $env:HTTP_X_REAL_IP}^if(def $env:HTTP_X_FORWARDED_FOR){, $env:HTTP_X_FORWARDED_FOR}]
#end @save_ip[]



##############################################################################
@save_manager[]
	^if($self.publish_manager){
		$self.manager_id($self.publish_manager)
	}
#end @save_manager[]



##############################################################################
@GET_status_info[]
	$result[$self.STATUSES.[$self.status_id]]
#end @GET_status_info[]