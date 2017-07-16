##############################################################################
#
##############################################################################

@CLASS
GeoCity

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
	^field[region_id][
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
	^validates_presence_of[geoname_id]
	^validates_presence_of[country_id]
#	^validates_presence_of[name]
#	^validates_presence_of[timezone]

	^rem{ *** ассесоры *** }

	^rem{ *** ассоциации *** }
	^belongs_to[country][
		$.class_name[GeoCountry]
		$.foreign_key[country_id]
	]
	^belongs_to[region][
		$.class_name[GeoRegion]
		$.foreign_key[region_id]
	]

	^scope[sorted][
		$.order[name ASC]
	]	
#end @auto[]



##############################################################################
@GET_site_region[]
	$result[^SiteRegion:first(1)[
		$.join[locations]
		$.condition[locations.geo_city_id = $self.id]
	]]
	^if(!$result){
		$result[^SiteRegion:first(1)[
			$.join[locations]
			$.condition[
				locations.geo_region_id = $self.region_id AND 
				locations.geo_city_id = 0
			]
		]]
	}

	^if(!$result){
		$result[^SiteRegion:first(1)[
			$.join[locations]
			$.condition[
				locations.geo_country_id = $self.country_id AND 
				locations.geo_region_id = 0 AND 
				locations.geo_city_id = 0
			]
		]]
	}
#end @GET_site_region[]