##############################################################################
#
##############################################################################

@CLASS
SiteRegion

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[code][
		$.type[string]
	]
	^field[name][
		$.type[string]
	]
	^field[phone][
		$.type[string]
	]
	^field[sort_order][
		$.type[int]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[name]
	^validates_presence_of[code][
		$.on[update]
	]

	^rem{*** ассоциации ***}
	^has_many[locations][
		$.class_name[SiteRegionToGeoRegion]
	]

	^rem{*** скоупы ***}
	^scope[sorted][
		$.order[site_region.sort_order ASC]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.code){
		$self.code[^Urlify:urlify[$self.name]]
	}

	^if(!$self.sort_order){
		$self.sort_order(^oSql.int{SELECT MAX(sort_order) FROM $self.table_name}[ $.default(0) ] + 1)
	}	
#end @before_create[]



##############################################################################
@GET_phone[]
	$result[$self.attributes.phone]

	^if(!def $result){
		$result[$DEFAULT_PHONE_NUMBER]		
	}
#end @GET_phone[]
