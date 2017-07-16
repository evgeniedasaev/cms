##############################################################################
#
##############################################################################

@CLASS
GeoRegion

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[geoname_id][
		$.type[int]
	]
	^field[country_id][
		$.type[int]
	]
	^field[parent_id][
		$.type[int]
	]
	^field[iso_code][
		$.type[string]
	]
	^field[name][
		$.type[string]
	]
	^field[timezone][
		$.type[string]
	]

	^rem{ *** валидаторы *** }
#	^validates_presence_of[geoname_id]
	^validates_presence_of[country_id]
#	^validates_presence_of[name]
#	^validates_presence_of[timezone]

	^rem{ *** ассесоры *** }

	^rem{ *** ассоциации *** }
	^belongs_to[country][
		$.class_name[GeoCountry]
		$.foreign_key[country_id]
	]
	^belongs_to[parent][
		$.class_name[GeoRegion]
		$.foreign_key[parent_id]
	]

	^rem{ *** скоупы *** }
	^scope[sorted][
		$.order[name ASC]
	]
#end @auto[]



##############################################################################
@GET_name[]
	$result[$self.attributes.name]
	^if(!def $result){
		$result[$self.iso_code]
	}
#end @GET_name[]
