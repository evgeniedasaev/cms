##############################################################################
#
##############################################################################

@CLASS
Vendor

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[code][
		$.type[string]
	]
	^field[name][
		$.type[string]
	]
	^field[delivery_days][
		$.type[int]
	]
	^field[dt_create][
		$.type[date]
	]
	^field[dt_update][
		$.type[date]
	]

	^rem{ *** валидаторы *** }
	^validates_presence_of[code][
		$.on[update]
	]
	^validates_presence_of[name]
	^validates_uniqueness_of[code]

	^rem{ *** ассоциации *** }
	^has_many[items][
		$.class_name[SKU]
	]

	^rem{ *** scopes *** }
	^scope[sorted][
		$.order[name]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	$self.dt_create[^date::now[]]

	^if(!def $self.code){
		$self.code[^Urlify:urlify[$self.name]]
	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]
#end @before_save[]
