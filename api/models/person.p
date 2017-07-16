##############################################################################
#
##############################################################################

@CLASS
Person

@OPTIONS
locals

@BASE
User



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** ассесоры *** }
	^field_accessor[passwd_confirmation]
#	^field_accessor[avatar]

	^rem{ *** ассоциации *** }
	^has_and_belongs_to_many[chiefs][
		$.class_name[User]
		$.join_table[user_subordinate]
		$.association_join_foreign_key[subordinate_user_id]
		$.dependent[void]
	]
	^has_and_belongs_to_many[subordinates][
		$.class_name[User]
		$.join_table[user_subordinate]
		$.join_foreign_key[subordinate_user_id]
		$.dependent[void]
	]
	^has_and_belongs_to_many[roles][
		$.class_name[Role]
		$.join_table[user_to_role]
		$.join_foreign_key[role_id]
		$.dependent[void]
	]

	^rem{ *** валидаторы *** }
# 	^validates_presence_of[title]
#end @auto[]
