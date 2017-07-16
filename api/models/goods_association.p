##############################################################################
#
##############################################################################

@CLASS
GoodsAssociation

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[type_id][
		$.name[goods_association_type_id]
		$.type[int]
	]
	^field[goods_id][															^rem{ *** основной товар *** }
		$.type[int]
	]
	^field[association_goods_id][												^rem{ *** ассоциированный товар *** }
		$.type[int]
	]
	^field[sort_order][
		$.type[int]
	]

	^validates_presence_of[type_id]
	^validates_presence_of[goods_id]
	^validates_presence_of[association_goods_id]
	^validates_uniqueness_of[association_goods_id][
		$.scope[type_id, goods_id]
	]
	
	^belongs_to[type][
		$.class_name[GoodsAssociationType]
		$.foreign_key[type_id]
	]
	^belongs_to[parent_goods][
		$.class_name[Goods]
		$.foreign_key[goods_id]
	]
	^belongs_to[goods][
		$.class_name[Goods]
		$.foreign_key[association_goods_id]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]
	
	^rem{ *** определяем sort_order *** }
	$self.sort_order(^oSql.int{SELECT MAX(sort_order) FROM $self.table_name WHERE goods_association_type_id = ^self.type_id.int(0) AND goods_id = ^self.goods_id.int(0)}[ $.default(0) ] + 1)
#end @before_create[]