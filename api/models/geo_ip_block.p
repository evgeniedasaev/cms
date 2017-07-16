##############################################################################
#	
##############################################################################

@CLASS
GeoIpBlock

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[geoname_id][
		$.type[int]
	]
	^field[country_id][
		$.type[int]
	]
	^field[region_id][
		$.type[int]
	]
	^field[city_id][
		$.type[int]
	]
	^field[mask_a][
		$.type[int]
	]
	^field[block_start][
		$.type[double]
	]
	^field[block_end][
		$.type[double]
	]
	^field[network][
		$.type[string]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[geoname_id]
	^validates_presence_of[country_id]
	^validates_presence_of[block_start]
	^validates_presence_of[block_end]

	^rem{*** ассоциации ***}
	^belongs_to[country][
		$.class_name[GeoCountry]
		$.foreign_key[country_id]
	]
	^belongs_to[region][
		$.class_name[GeoRegion]
		$.foreign_key[region_id]
	]
	^belongs_to[city][
		$.class_name[GeoCity]
		$.foreign_key[city_id]
	]
#end @auto[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$start[^inet:ntoa($self.block_start)]
	$oktets[^start.split[.][lh]]
	
	$self.mask_a[$oktets.0]
#end @before_save[]



##############################################################################
@GET_region_str[]
	$result[$self.country.name_ru^if($self.region){, $self.region.name}^if($self.city){, $self.oGeo.city.name}]
#end @GET_region_str[]



##############################################################################
@static:search_by_ip[iIPAddress]
	$ip[^inet:ntoa($iIPAddress)]
	$oktets[^ip.split[.][lh]]
	
	$result[^self.CLASS.find_first[
		$.condition[mask_a = $oktets.0 AND $iIPAddress BETWEEN block_start AND block_end]
	]]
#end @static:search_by_ip[]