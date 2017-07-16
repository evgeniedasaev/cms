##############################################################################
#	
##############################################################################

@CLASS
MailingCampaignQueue

@OPTIONS
locals

@BASE
QueueModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[mailing_campaign_id][
		$.type[int]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[mailing_campaign_id]

	^rem{*** ассоциации ***}	
	^belongs_to[mailing_campaign][
		$.touch[update_status]
	]
# 	^has_many[mailing_queues][
# 		$.class_name[MailingQueue]
# 		$.through[mailing_campaign]
# 		$.association[mailing_queues]
# 		$.touch[update_status]
# 	]
#end @auto[]



##############################################################################
@GET_mailing_queues[]
	$result[$self.mailing_campaign.mailing_queues]
#end @GET_mailing_queues[]



##############################################################################
# 	Поиск задачи в очереди по уникальному ключу, 
#	если запись не нашли - создаем
##############################################################################
@static:find_or_create[hOptions]
	^if(^hOptions.mailing_campaign_id.int(0)){
		$result[^self.find[
			$.condition[mailing_campaign_id = $hOptions.mailing_campaign_id]
		]]
	}

	^if(!def $result){
		$result[^BASE:find_or_create[$hOptions]]
	}
#end @static:find_or_create[]