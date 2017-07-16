##############################################################################
#	
##############################################################################

@CLASS
GoodsSerieImageToGoods

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[goods_serie_id][
		$.type[int]
	]
	^field[goods_serie_image_id][
		$.type[int]
	]
	^field[goods_id][
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
	^validates_presence_of[goods_serie_image_id]

	^rem{*** ассоциации ***}
	^belongs_to[goods][
		$.class_name[Goods]
	]
	^belongs_to[image][
		$.class_name[GoodsSerieImage]
	]
	^belongs_to[goods_serie][
		$.class_name[GoodsSerie]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	^if($self.goods_serie_image_id){
		$self.goods_serie_id[$self.image.goods_serie_id]
	}
#end @before_save[]
