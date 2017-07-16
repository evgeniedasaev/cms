##############################################################################
#
##############################################################################

@CLASS
GoodsFileType

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
	^field[is_image][
		$.type[bool]
	]
	^field[sort_order][
		$.type[int]
	]
	^field[alias][
		$.type[string]
	]

	^validates_presence_of[name]
	^validates_uniqueness_of[alias]

	^has_many[files][
		$.class_name[GoodsFile]
		$.foreign_key[type_id]
		$.dependent[nulled]
	]

	^scope[sorted][
		$.order[sort_order ASC]
	]
#end @auto[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	^rem{ *** если новый *** }
	^if($self.is_new){
		^rem{ *** определяем sort_order *** }
		$self.sort_order(^oSql.int{SELECT MAX(sort_order) FROM $self.table_name}[ $.default(0) ] + 1)
	}
#end @before_save[]
