##############################################################################
#	
##############################################################################

@CLASS
MailingGroup

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[name][
		$.type[string]
	]
	^field[code][
		$.type[string]
	]
	^field[is_public][
		$.type[bool]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[name]
	^validates_uniqueness_of[code]

	^rem{*** ассоциации ***}	
	^has_and_belongs_to_many[users][
		$.class_name[User]
		$.join_table[mailing_group_to_user]
	]	
	^has_and_belongs_to_many[mailing_campaigns][
		$.class_name[MailingCampaign]
		$.join_table[mailing_campaign_to_mailing_group]
	]
	^has_many[user_subscriptions][
		$.class_name[MailingGroupToUser]
	]

	^rem{*** скоупы ***}
	^scope[public][
		$.condition[is_public = 1]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.code){
		^rem{ *** генерируем permalink путем транслита названия и удаления запрещенных символов *** }
		$self.code[^Urlify:urlify[$self.name]]
	}
#end @before_create[]