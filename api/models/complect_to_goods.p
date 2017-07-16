##############################################################################
#	
##############################################################################

@CLASS
ComplectToGoods

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[complect_id][
		$.type[int]
	]
	^field[goods_id][
		$.type[int]
	]
	^field[goods_file_id][
		$.type[int]
	]
	^field[x][
		$.type[int]
	]
	^field[y][
		$.type[int]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[goods_id]
	^validates_presence_of[complect_id]	

	^rem{*** ассоциации ***}
	^belongs_to[complect][
		$.class_name[Goods]
		$.foreign_key[complect_id]
	]			
	^belongs_to[goods]
	^belongs_to[image][
		$.class_name[GoodsFile]
		$.foreign_key[goods_file_id]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]
#end @before_save[]