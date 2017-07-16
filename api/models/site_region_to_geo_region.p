##############################################################################
#	
##############################################################################

@CLASS
SiteRegionToGeoRegion

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[site_region_id][
		$.type[int]
	]
	^field[geo_country_id][
		$.type[int]
	]
	^field[geo_region_id][
		$.type[int]
	]
	^field[geo_city_id][
		$.type[int]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}

	^rem{*** ассоциации ***}
	^belongs_to[site_region]
	^belongs_to[country][
		$.class_name[GeoCountry]
		$.foreign_key[geo_country_id]
	]
	^belongs_to[region][
		$.class_name[GeoRegion]
		$.foreign_key[geo_region_id]
	]
	^belongs_to[city][
		$.class_name[GeoCity]
		$.foreign_key[geo_city_id]		
	]			
#end @auto[]