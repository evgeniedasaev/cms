##############################################################################
# Шаблоны рассылок
##############################################################################

@CLASS
MailingTemplate

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[mailing_layout_id][
		$.type[int]
	]
	^field[name][
		$.type[string]
	]
	^field[code][
		$.type[string]
	]
	^field[body][
		$.type[string]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[mailing_layout_id]
	^validates_presence_of[name]
	^validates_uniqueness_of[code]

	^rem{*** ассоциации ***}		
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.code){
		^rem{ *** генерируем permalink путем транслита названия и удаления запрещенных символов *** }
		$self.code[^Urlify:urlify[$self.name]]
	}
#end @before_create[]



##############################################################################
@GET_layout[]
	$result[$MESSAGE_LAYOUTS_BY_ID.[$self.mailing_layout_id]]
#end @GET_layout[]