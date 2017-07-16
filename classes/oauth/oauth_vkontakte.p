##############################################################################
#
##############################################################################

@CLASS
OAuthVkontakte

@OPTIONS
locals

@BASE
OAuthBase



##############################################################################
@auto[]
	$self.service[$SocialLogin:TYPES.vk.code]
	$self.access_token_url[https://oauth.vk.com/access_token]
	$self.authenticate_url[https://oauth.vk.com/authorize]
	$self.users_get_url[https://api.vk.com/method/users.get]

	$self.app_id[$SOCIAL_LOGINS_DATA.[$self.service].app_id]
	$self.app_secret[$SOCIAL_LOGINS_DATA.[$self.service].app_secret]
#end @auto[]



##############################################################################
@access_token[hParams]
	^hParams.add[
		$.client_id[$self.app_id]
		$.client_secret[$self.app_secret]
	]
	$result[^load[GET;$self.access_token_url;$hParams;json]]
#end @access_token[]



##############################################################################
@users_get[hParams]
	^hParams.add[
		$.v[5.23]
	]
	$result[^load[GET;$self.users_get_url;$hParams;json]]
	^if($result.response){
		$result[$result.response.0]
	}
#end @users_get[]



##############################################################################
@load[sMethod;sUrl;hParams;sResultType]
	$params[
		$.body[^hash::create[$hParams]]
	]
	$params.method[$sMethod]

	$result[^_load_curl[$sUrl;$params;$sResultType]]
#end @load[]