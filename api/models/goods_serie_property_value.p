
##############################################################################
#	
##############################################################################

@CLASS
GoodsSeriePropertyValue

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
  ^BASE:auto[]

	$self.CACHE_ENABLED(false)

	^rem{ *** аттрибуты *** }
	^field[goods_serie_id][
	  $.type[int]
	]
	^field[goods_property_id][
	  $.type[int]
	]
	^field[goods_property_posible_value_id][
		$.type[int]
	]

  ^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }
	^validates_presence_of[goods_serie_id]
	^validates_presence_of[goods_property_id]

	^rem{ *** ассоциации *** }
  ^belongs_to[goods_serie]
  ^belongs_to[property][
		$.class_name[GoodsProperty]
	]
	^belongs_to[posible_value][
		$.class_name[GoodsPropertyPosibleValue]
	]
#end @auto[]



##############################################################################
@GET_value[]
	$result[$self.posible_value.description]
#end @GET_value[]



##############################################################################
@GET_val[][result]
	^switch($self.property.value_type_id){
		^case(4){
			$result[^dtf:format[%d.%m.%Y;$self.posible_value.description]]
		}
		^case[DEFAULT]{
			$result[$self.posible_value.description]
		}
	}
#end @GET_val[]



##############################################################################
@GET_full_name[]
	$result[<strong>$self.property.name</strong>: <span>$self.val $self.property.unit</span>]
#end @GET_full_name[]
