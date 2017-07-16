##############################################################################
#
##############################################################################

@CLASS
OAuthFacebook

@OPTIONS
locals

@BASE
OAuthBase



##############################################################################
@auto[]
	$self.service[$SocialLogin:TYPES.fb.code]
	$self.access_token_url[https://graph.facebook.com/oauth/access_token]
	$self.authenticate_url[https://www.facebook.com/dialog/oauth]
	$self.me_url[https://graph.facebook.com/me]

	$self.app_id[$SOCIAL_LOGINS_DATA.[$self.service].app_id]
	$self.app_secret[$SOCIAL_LOGINS_DATA.[$self.service].app_secret]
#end @auto[]



##############################################################################
@access_token[hParams]
	^hParams.add[
		$.client_id[$self.app_id]
		$.client_secret[$self.app_secret]
	]
	$result[^load[GET;$self.access_token_url;$hParams]]
#end @access_token[]



##############################################################################
@me[hParams]
	$result[^load[GET;$self.me_url;$hParams;json]]
#end @me[]



##############################################################################
@load[sMethod;sUrl;hParams;sResultType]
	$params[
		$.body[^hash::create[$hParams]]
	]
	$params.method[$sMethod]

	$result[^_load_curl[$sUrl;$params;$sResultType]]
#end @load[]