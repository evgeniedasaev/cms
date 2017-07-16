##############################################################################
#	
##############################################################################

@CLASS
UserRight

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
	]
	^field[object_type][
		$.type[string]
	]
	^field[object_id][
		$.type[int]
	]
	^field[rights_allow][
		$.type[int]
	]
	^field[rights_deny][
		$.type[int]
	]
	^rem{ *** ассесоры *** }

	^rem{ *** ассоциации *** }
	^belongs_to[user][
		$.class_name[User]
		$.foreign_key[user_id]
	]

	^rem{ *** валидаторы *** }
	^validates_presence_of[user_id]
	^validates_presence_of[object_type]
	^validates_presence_of[object_id]
	^validates_presence_of[rights_allow]
	^validates_presence_of[rights_deny]
#end @auto[]



##############################################################################
@GET_allow[]
	$result($self.rights_allow)
#end @GET_allow[]



##############################################################################
@GET_deny[]
	$result($self.rights_deny)
#end @GET_deny[]



##############################################################################
#	Хелпер для быстрого сбора прав в дерево с помощью map
##############################################################################
@GET_rights[]
	$result[
		$.allow($self.rights_allow)
		$.deny($self.rights_deny)
	]
#end @GET_rights[]
