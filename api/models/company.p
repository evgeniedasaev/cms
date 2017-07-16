##############################################################################
#
##############################################################################

@CLASS
Company

@OPTIONS
locals

@BASE
User



##############################################################################
@auto[]
	^BASE:auto[]
	
	^has_many[team][
		$.class_name[UserToCompany]
		$.foreign_key[company_id]
		$.include[user]
		$.order[user_to_company_id, ISNULL(position), position]
	]
	^has_many[users][
		$.association[user]
		$.through[team]
	]
	
	^rem{ *** валидаторы *** }
	^validates_presence_of[title]
#end @auto[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.company[$self.title]
#end @before_save[]