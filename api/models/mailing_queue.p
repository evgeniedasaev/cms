##############################################################################
#	
##############################################################################

@CLASS
MailingQueue

@OPTIONS
locals

@BASE
QueueModel



##############################################################################
@auto[]
	^BASE:auto[]

	$self.STATUSES[
		$.in_progress[
			$.id(0)
			$.code[in_progress]
			$.name[Выполняется]
		]
		$.pause[
			$.id(10)
			$.code[pause]
			$.name[Остановлено]
		]
	]

	^rem{*** поля ***}
	^field[mailing_campaign_id][
		$.type[int]
	]
	^field[user_id][
		$.type[int]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[mailing_campaign_id]
	^validates_presence_of[user_id]


	^rem{*** ассоциации ***}	
	^belongs_to[user]
	^belongs_to[mailing_campaign][
		$.class[MailingCampaign]
		$.touch[update_status]
	]	
# 	^has_many[mailing_campaign_queues][
# 		$.through[mailing_campaign]
# 		$.association[mailing_campaign_queue]
# 	]	
#end @auto[]



##############################################################################
# 	Поиск задачи в очереди по уникальному ключу, 
#	если запись не нашли - создаем
##############################################################################
@static:find_or_create[hOptions]
	^if(^hOptions.mailing_campaign_id.int(0) && ^hOptions.user_id.int(0)){
		$result[^self.first(0)[
			$.condition[
				mailing_campaign_id = $hOptions.mailing_campaign_id AND
				user_id = $hOptions.user_id
			]
		]]
		$result[$result.0]
	}

	^if(!def $result){
		$result[^BASE:find_or_create[$hOptions]]
	}
#end @static:find_or_create[]