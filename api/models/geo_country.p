##############################################################################
#
##############################################################################
@CLASS
GeoCountry

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
	^field[iso_code][
		$.type[string]
	]
	^field[name][
		$.type[string]
	]

	^rem{ *** валидаторы *** }
	^validates_presence_of[geoname_id]
	^validates_presence_of[iso_code]
	^validates_presence_of[name]

	^rem{ *** связи *** }
	^has_many[regions][
		$.class_name[GeoRegion]
	]
	^has_many[cities][
		$.class_name[GeoCity]
	]

	^rem{ *** скоупы *** }
	^scope[sorted][
		$.order[name ASC]
	]
#end @auto[]
