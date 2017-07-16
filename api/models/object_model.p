##############################################################################
#	
##############################################################################

@CLASS
ObjectModel

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	$self.OBJECT_STATUSES[^enum::create[
		$.active[
			$.id[0]
			$.name[active]
		]
		$.draft[
			$.id[1]
			$.name[draft]
		]
		$.deleted[
			$.id[10]
			$.name[deleted]
		]
	]]

	^BASE:auto[]	

	^rem{ *** аттрибуты *** }
	^field[object_status_id][
		$.type[int]
	]
	
	^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }

	^rem{ *** ассоциации *** }

	^rem{ *** scopes *** }
	^default_scope[
		$.condition[`${self.table_name}`.`object_status_id` IN ($self.OBJECT_STATUSES.active.id)]
	]
#end @auto[]



##############################################################################
@GET_object_status[]
	$result[$self.OBJECT_STATUSES.[$self.object_status_id]]
#end @GET_object_status[]




##############################################################################
#	Перекрываем удаление объекта на установку статуса DELETED
##############################################################################
@_delete[]
	$self.object_status_id($self.OBJECT_STATUSES.deleted.id)					^rem{ *** устанавливаем статус deleted *** }
	
	^if(!^self.save[]){
		^throw_inspect[^self.errors.array[]]
	}
#end @_delete[]