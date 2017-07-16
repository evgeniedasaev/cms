##############################################################################
#	
##############################################################################

@CLASS
MailingCampaign

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	$self.STATUSES[^enum::create[
		$.new[
			$.id(0)
			$.code[new]
			$.name[Новая]
			$.action[Запустить]
			$.color[#dff0d8]
		]
		$.done[
			$.id(1)
			$.code[done]
			$.name[Завершена]
			$.action[Перезапустить]
			$.color[#f5f5f5]
		]
		$.in_progress[
			$.id(2)
			$.code[in_progress]
			$.name[В работе]
			$.action[Остановить]
			$.color[#f2dede]
		]
		$.pause[
			$.id(3)
			$.code[pause]
			$.name[Приостановлена]
			$.action[Возобновить]
			$.color[#d9edf7]
		]
	]]

	^rem{*** поля ***}
	^field[name][
		$.type[string]
	]
	^field[mailing_template_id][
		$.type[int]
	]
	^field[body][
		$.type[string]
	]
	^field[status][
		$.type[string]
	]
	^field[dt][
		$.type[date]
	]
	^field[dt_create][
		$.type[date]
	]
	^field[dt_update][
		$.type[date]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[name]
	^validates_presence_of[mailing_template_id]

	^rem{*** ассоциации ***}		
	^belongs_to[mailing_template]
	^has_and_belongs_to_many[mailing_groups][
		$.class_name[MailingGroup]
		$.join_table[mailing_campaign_to_mailing_group]
	]
	^has_many[mailing_queues][
		$.class_name[MailingQueue]
	]
	^has_one[mailing_campaign_queue]
	^rem{*** Видимо не работает с has_and_belongs_to_many
	^has_many[users][
		$.through[mailing_groups]
		$.association[users]
		$.condition[users.is_published = 1]
	]	
	*** }
	^has_many[mailing_mails][
		$.class_name[MailingMail]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.dt_create){
		$self.dt_create[^date::now[]]
	}

	^if(!def $self.status){
		$self.status[$self.CLASS.STATUSES.new.code]
	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]
#end @before_save[]



##############################################################################
@GET_users[]
	$result[^User:published[
		$.join[
			$.[mailing_groups](true)
			$.[mailing_groups.mailing_campaigns][
				$.condition[mailing_campaigns.mailing_campaign_id = $self.id]
			]
		]
		$.condition[user.email != "" OR user.email IS NOT NULL]
	]]
#end @GET_users[]



##############################################################################
@GET_layout[]      
	$result[$self.mailing_template.layout]
#end @GET_layout[]



##############################################################################
@GET_body_with_layout[]
	$result[^self.mailing_template.body.match[{{body}}][gi]{$self.body}]
#end @GET_body_with_layout[]



##############################################################################
@GET_progress_status_str[]
	$result[$self.STATUSES.[$self.attributes.status].name]
#end @GET_progress_status_info[]



##############################################################################
@GET_progress_status_info[]
	$result[$self.STATUSES.[$self.attributes.status]]
#end @GET_progress_status_info[]



##############################################################################
@GET_is_in_progress[]
	$result($self.progress_status_info.code eq $self.CLASS.STATUSES.in_progress.code)
#end @GET_is_in_progress[]



##############################################################################
@GET_is_done[]
	$result($self.progress_status_info.code eq $self.CLASSSTATUSES.done.code)
#end @GET_is_done[]


##############################################################################
# Обновляем статус рассылки
##############################################################################
@update_status[]
	^if($self.mailing_campaign_queue){
		^if($self.mailing_campaign_queue.is_in_progress){
			$self.status[$self.CLASS.STATUSES.in_progress.code]
		}{
			$self.status[$self.CLASS.STATUSES.pause.code]
		}
	}(^self.mailing_queues.count[]){
		$paused_mails[^self.mailing_queues.paused[]]
		$paused_mails[^paused_mails.count[]]

		^if($paused_mails){
			^rem{*** если по рассылке есть письма, но они находятся на паузе - пишем, что рассылка на паузе ***}
			$self.status[$self.CLASS.STATUSES.pause.code]
		}{
			$self.status[$self.CLASS.STATUSES.in_progress.code]
		}
	}{
		^rem{*** если нет ни новых заданий, ни заданий на паузе, а также заданий на подготовку - выполнена ***}
		$self.status[$self.CLASS.STATUSES.done.code]			
	}

	^if(!^self.save[]){
		^throw_inspect[^self.errors.array[]][^inspect[$self.attributes]]
	}
#end @update_status[]