##############################################################################
#
##############################################################################

@CLASS
SeoTextPattern

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[group][
		$.type[string]
	]
	^field[name][
		$.type[string]
	]
	^field[pattern_type][
		$.name[type]
		$.type[string]
	]
	^field[pattern][
		$.type[string]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[pattern]
	^validates_presence_of[pattern_type]

	^rem{*** ассоциации ***}
#end @auto[]



##############################################################################
@GET_type[]
	$result[$self.pattern_type]
#end @GET_type[]
