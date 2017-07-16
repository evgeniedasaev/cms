##############################################################################
#	
##############################################################################

@CLASS
UserCID

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]
	
	$self._primary_key[cid]

	^rem{ *** аттрибуты *** }
	^field[is_free][
		$.type[int]
		$.is_protected(true)
	]
	
	^rem{ *** ассоциации *** }
	^has_many[sessions][
		$.class_name[Session]
	]
	
	^rem{ *** валидаторы *** }
	
	
	^rem{ *** scopes *** }
	^scope[free][
		$.condition[is_free = 1]
		$.order[cid]
	]
#end @auto[]
