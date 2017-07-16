##############################################################################
#	
##############################################################################

@CLASS
SkuProperty

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[sku_id][
		$.type[int]
	]
	^field[code][
		$.type[string]
	]	
	^field[value][
		$.type[string]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}

	^rem{*** ассоциации ***}	
	^belongs_to[SKU][
		$.foreign_key[sku_id]
		$.class_name[SKU]
	]
#end @auto[]
