##############################################################################
#
##############################################################################

@CLASS
StatHit

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[session_id][
		$.type[int]
	]
	^field[user_id][
		$.type[int]
	]
	
	^field[domain][
		$.type[string]
	]
	^field[uri][
		$.type[string]
	]
	^field[region_id][
		$.type[int]
	]

	^field[referer][
		$.type[string]
	]
	
	^field[utm_source][
		$.type[string]
	]
	^field[utm_campaign][
		$.type[string]
	]
	^field[utm_content][
		$.type[string]
	]
	^field[utm_medium][
		$.type[string]
	]
	^field[utm_term][
		$.type[string]
	]
	^field[openstat][
		$.type[string]
	]
	^field[yclid][
		$.type[string]
	]
	^field[gclid][
		$.type[string]
	]
	
	^field[ad_position_type][
		$.type[string]
	]
	^field[ad_position][
		$.type[string]
	]
	
	^field[remote_addr][
		$.type[string]
	]
	^field[forwarded_for][
		$.type[string]
	]
	
	^field[user_agent][
		$.type[string]
	]

	^field[dt_create][
		$.type[date]
	]
	^field[dt_sent][
		$.type[date]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]
	
	^if(!$self.dt_create){
		$self.dt_create[^date::now[]]
	}
	^if(!$self.dt_sent){
		$self.dt_sent[^date::now[]]
	}
#end @before_create[]
