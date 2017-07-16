##############################################################################
#
##############################################################################

@CLASS
GoodsAssociationType

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[name][
		$.type[string]
	]
	^field[code][
		$.type[string]
	]
	^field[sort_random][
		$.type[bool]
	]
	^field[sort_order][
		$.type[int]
	]

	^rem{ *** валидаторы *** }
	^validates_presence_of[name]
	^validates_presence_of[code]
	^validates_uniqueness_of[code]

	^rem{ *** связи *** }
#	^has_many[associations][
#		$.class_name[GoodsAssociation]
#
#		$.dependent[destroy]
#	]

	^scope[sorted][
		$.order[sort_order ASC]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^rem{ *** определяем sort_order *** }
	$self.sort_order(^oSql.int{SELECT MAX(sort_order) FROM $self.table_name}[ $.default(0) ] + 1)
#end @before_create[]
