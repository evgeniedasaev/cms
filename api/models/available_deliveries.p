##############################################################################
#
##############################################################################

@CLASS
AvailableDeliveries

@OPTIONS
locals

@BASE
ActiveModel

##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[delivery_type_id][
		$.type[int]
	]
	^field[geo_city_id][
		$.type[int]
	]
	^field[geo_region_id][
		$.type[int]
	]
	^field[geo_country_id][
		$.type[int]
	]

	^rem{ *** ассесоры *** }
	^rem{ *** валидаторы *** }
	^validates_presence_of[delivery_type_id]
	^validate_with[uniqueness]

	^rem{ *** ассоциации *** }
	^belongs_to[delivery][
		$.class_name[Delivery]
	]
	^belongs_to[geo_city]
	^belongs_to[geo_region]
	^belongs_to[geo_country]
#end of @auto


##############################################################################
@uniqueness[hParams]
#	delivery_type_id geo_country_id geo_region_id geo_city_id
	^if(
		^AvailableDeliveries:count[
			$.condition[
				delivery_type_id = ^self.delivery_type_id.int(0) AND
				geo_country_id = $self.geo_country_id AND
				geo_region_id = $self.geo_region_id AND
				geo_city_id = $self.geo_city_id
			]
		]
	){
		^self.errors.append[available_deliveries;available_deliveries_uniqueness;Такая зона доставки уже существует]
	}
#end of @uniqueness



##############################################################################
@before_create[]
	^BASE:before_create[]

#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

#end @before_save[]
