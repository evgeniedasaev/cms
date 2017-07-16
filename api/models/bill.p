##############################################################################
#
##############################################################################

@CLASS
Bill

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	$self.STATUSES[^enum::create[
		$.0[
			$.id[0]
			$.name[Не оплачен]
			$.color[gray]
		]
		$.1[
			$.id[1]
			$.name[Оплачен]
			$.color[#00CC00]
		]
		$.2[
			$.id[2]
			$.name[Требует проверки]
			$.color[red]
		]
	]]
	
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[order_id][
		$.type[int]
	]
	^field[payment_type_id][
		$.type[int]
	]
	^field[price][
		$.type[double]
	]
	^field[dt][
		$.type[date]
	]
	^field[status_id][
		$.type[int]
	]
	^field[is_confirm][
		$.type[bool]
	]
	^field[dt_update][
		$.type[date]
	]

	^rem{ *** валидаторы *** }
	^validates_presence_of[order_id]
	^validates_presence_of[price]
	
	^rem{ *** связи *** }
	^belongs_to[order][
		$.touch(true)
	]
	^belongs_to[payment_type]
#end @auto[]



##############################################################################
@GET_status[]
	$result[$self.STATUSES.[$self.status_id]]
#end @GET_status[]



##############################################################################
@before_create[]
	^BASE:before_create[]
	
	$self.dt[^date::now[]]
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]
	
	$self.dt_update[^date::now[]]
#end @before_save[]
