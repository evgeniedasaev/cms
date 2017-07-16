##############################################################################
#	
##############################################################################

@CLASS
GoodsFavorite

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[user_id][
		$.type[int]
	]
	^field[goods_id][
		$.type[int]
	]
	^field[goods_name][
		$.type[string]
	]
	^field[dt_create][
		$.type[date]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[user_id]
	^validates_presence_of[goods_id]

	^rem{*** ассоциации ***}		
	^belongs_to[user]
	^belongs_to[goods]

	^rem{*** скоупы ***}
	^scope[sorted][
		$.order[dt_create DESC]
	]	
#end @auto[]



##############################################################################
#	Наименование
##############################################################################
@GET_name[]
	$result[$self.goods_name]
#end @GET_name[]



##############################################################################
#	Цена
##############################################################################
@GET_price[]
	$result[$self.goods.price]
#end @GET_price[]


##############################################################################
#	Скидка
##############################################################################
@GET_price_discount[]
	$result[$self.goods.price_discount]
#end @GET_price_discount[]


##############################################################################
#	Тип скидки
##############################################################################
@GET_price_discount_type_id[]
	$result[$self.goods.price_discount_type_id]
#end @GET_price_discount_type_id[]



##############################################################################
#	Экономия
##############################################################################
@GET_saving[]
	$result(0)

	^if($self.price_discount){
		^switch[$self.price_discount_type_id]{
			^case(0){
				$result($self.price * $self.price_discount / 100)
			}		
			^case[DEFAULT]{
				$result($self.price_discount * $Currency:all.[$self.price_discount_type_id].rate)
			}
		}
	}	
#end @GET_saving[]



##############################################################################
#	Итого со скидкйо на конкретный товар
##############################################################################
@GET_total_with_saving[]
	$result($self.price - $self.saving)
#end @GET_total_with_saving[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.dt_create){
		$self.dt_create[^date::now[]]
	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	^if($self.goods && !def $self.goods_name){
		$self.goods_name[${self.goods.type_prefix_title} ${self.goods.model} ${self.goods.postfix}]
	}
#end @before_save[]