##############################################################################
#
##############################################################################

@CLASS
Navigation

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[sort_order][
		$.type[int]
	]
	^field[name][
		$.type[string]
	]
	^field[description][
		$.type[string]
	]

	^validates_presence_of[name]
	^validates_presence_of[description]


	^scope[sorted][
		$.order[sort_order]
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
