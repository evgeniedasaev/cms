##############################################################################
#
##############################################################################

@CLASS
Group

@OPTIONS
locals

@BASE
User



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** ассоциации *** }
	^has_and_belongs_to_many[users][
		$.class_name[User]
		$.join_table[user_to_group]
		$.association_join_foreign_key[group_id]
		$.dependent[void]
	]

	^rem{ *** валидаторы *** }
	^validates_presence_of[title]
#end @auto[]
