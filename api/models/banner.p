##############################################################################
#	
##############################################################################

@CLASS
Banner

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[title][
		$.type[string]
	]
	^field[link][
		$.type[string]
	]
	^field[image_file_name][
		$.type[string]
	]
	^field[html][
		$.type[string]
	]
	^field[is_published][
		$.type[bool]
	]
	^field[sort_order][
		$.type[int]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_file_of[image]
	^validates_image_of[image]

	^rem{*** ассоциации ***}
	^has_attached_image[image][
		$.S[
			$.0[
				$.action[resize]

				$.width[150]
				$.height[150]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.L[
			$.0[
				$.action[resize]

				$.width[0]
				$.height[612]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
	]

	^rem{*** скоупы ***}
	^scope[published][
		$.condition[is_published = 1]
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