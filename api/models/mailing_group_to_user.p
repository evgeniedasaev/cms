##############################################################################
#	
##############################################################################

@CLASS
MailingGroupToUser

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[mailing_group_id][
		$.type[int]
	]
	^field[user_id][
		$.type[int]
	]
	^field[email][
		$.type[string]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}

	^rem{*** ассоциации ***}		
	^belongs_to[mailing_group]
	^belongs_to[user]
#end @auto[]