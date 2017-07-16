##############################################################################
#
##############################################################################

@CLASS
OAuthYandex

@OPTIONS
locals

@BASE
OAuthBase



##############################################################################
@auto[]
	$self.service[$SocialLogin:TYPES.ya.code]
	$self.access_token_url[https://oauth.yandex.ru/token]
	$self.authenticate_url[https://oauth.yandex.ru/authorize]
	$self.login_info_url[https://login.yandex.ru/info]

	$self.app_id[$SOCIAL_LOGINS_DATA.[$self.service].app_id]
	$self.app_secret[$SOCIAL_LOGINS_DATA.[$self.service].app_secret]
#end @auto[]



##############################################################################
@access_token[hParams]
	^hParams.add[
		$.grant_type[authorization_code]
		$.client_id[$self.app_id]
		$.client_secret[$self.app_secret]
	]
	$result[^load[POST;$self.access_token_url;$hParams;json]]
#end @access_token[]



##############################################################################
@login_info[hParams]
	^hParams.add[
		$.format[json]
	]
	$result[^load[GET;$self.login_info_url;$hParams;json]]
#end @login_info[]



##############################################################################
@load[sMethod;sUrl;hParams;sResultType]
	$params[
		$.body[^hash::create[$hParams]]
	]
	$params.method[$sMethod]

	$result[^_load_curl[$sUrl;$params;$sResultType]]
#end @load[]