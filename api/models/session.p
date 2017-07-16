##############################################################################
#	
##############################################################################

@CLASS
Session

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[user_id][
		$.type[int]
		$.is_protected(true)
	]
	^field[sid][
		$.type[string]
		$.is_protected(true)
	]
	^field[uid][
		$.type[string]
		$.is_protected(true)
	]
	^field[cid][
		$.type[int]
	]	
	^field[remote_addr][
		$.type[string]
	]
	^field[forwarded_for][
		$.type[string]
	]
	^field[user_agent_hash][
		$.type[string]
	]
	^field[dt_create][
		$.type[datetime]
		$.is_protected(true)
	]
	^field[dt_access][
		$.type[datetime]
		$.is_protected(true)
	]
	
	^rem{ *** ассоциации *** }
	^belongs_to[user]
	
	^rem{ *** валидаторы *** }
	^validates_numericality_of[user_id][
		$.is_integer(true)
	]

#	^validates_presence_of[sid]
	^validates_uniqueness_of[sid]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	$self.sid[^self.generateSessionId[]]
	^if(!def $self.uid){
		$self.uid[^self.generateSessionId[]]
	}
	
	^if(!$self.dt_create){
		$self.dt_create[^date::now[]]
	}
	^if(!$self.dt_access){
		$self.dt_access[^date::now[]]
	}
#end @before_create[]



##############################################################################
@generateSessionId[]
	$result[^math:uuid[]]
#end @generateSessionId[]



##############################################################################
@cryptUserAgent[sUserAgent]
	$result[^math:md5[$sUserAgent]]
#end @cryptUserAgent[]
