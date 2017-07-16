##############################################################################
#
##############################################################################

@CLASS
Tag

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

	^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }
	^validates_presence_of[name]

	^rem{ *** связи *** }
	^has_and_belongs_to_many[posts][
		$.class_name[Post]
		$.join_table[post_to_tag]
	]
#end @auto[]
