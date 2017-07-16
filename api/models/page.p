##############################################################################
#
##############################################################################

@CLASS
Page

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@GET_DEFAULT[sName][result]
	^if(^sName.pos[GET_] && ^sName.pos[SET_] && ^sName.pos[_] && $self.attributes && $self.object){
		$self.object.[$sName]
	}
#end @GET_DEFAULT[]



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[object_id][
		$.type[int]
	]
	^field[meta_keywords][
		$.type[string]
	]
	^field[meta_description][
		$.type[string]
	]
	^field[title][
		$.type[string]
	]
	^field[header][
		$.type[string]
	]
	^field[body][
		$.type[string]
	]
	
	^belongs_to[object]
#end @auto[]