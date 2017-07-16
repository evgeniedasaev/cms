##############################################################################
#
##############################################################################

@CLASS
SocialLogin

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	$self.TYPES[^enum::create[
		$.tw[
			$.id[5]
			$.code[twitter]
			$.name[Twitter]
			$.icon[twitter]
			$.svg_offset_top(117.8)
			$.svg_offset_left(11.38)
		]
		$.fb[
			$.id[0]
			$.code[facebook]
			$.name[Facebook]
			$.icon[facebook]
			$.svg_offset_top(118)
			$.svg_offset_left(0)
		]
		$.vk[
			$.id[2]
			$.code[vkontakte]
			$.name[ВКонтакте]
			$.icon[vk]
			$.svg_offset_top(118)
			$.svg_offset_left(11.5)
		]
		$.ya[
			$.id[4]
			$.code[yandex]
			$.name[Яндекс.Логин]
			$.icon[mail]
			$.svg_offset_top(118)
			$.svg_offset_left(11.8)			
		]
		$.ok[
			$.id[3]
			$.code[odnoklassniki]
			$.name[Одноклассники]
			$.icon[odnoklassniki]
			$.svg_offset_top(118)
			$.svg_offset_left(11.6)			
		]
	]]

	^rem{ *** аттрибуты *** }
	^field[user_id][
		$.type[int]
	]
	^field[service][
		$.name[type]
		$.type[string]
	]
	^field[ext_user_id][
		$.type[string]
	]
	^field[ext_login][
		$.type[string]
	]
	^field[token][
		$.type[text]
	]
	^field[secret][
		$.type[text]
	]
	^field[expires_in][
		$.type[int]
	]
	^field[dt_create][
		$.type[date]
	]
	^field[dt_update][
		$.type[date]
	]

	^validates_presence_of[user_id]
	^validates_presence_of[service]
	^validates_presence_of[ext_user_id]

	^belongs_to[user]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	$self.dt_create[^date::now[]]
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]
#end @before_save[]



##############################################################################
@GET_type[]
	$result[$self.service]
#end @GET_type[]