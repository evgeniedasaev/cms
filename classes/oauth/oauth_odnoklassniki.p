##############################################################################
#
##############################################################################

@CLASS
OAuthOdnoklassniki

@OPTIONS
locals

@BASE
OAuthBase



##############################################################################
@auto[]
	$self.service[$SocialLogin:TYPES.ok.code]
	$self.access_token_url[http://api.odnoklassniki.ru/oauth/token.do]
	$self.authenticate_url[http://www.odnoklassniki.ru/oauth/authorize]
	$self.get_current_user_url[http://api.odnoklassniki.ru/fb.do]

	$self.app_id[$SOCIAL_LOGINS_DATA.[$self.service].app_id]
	$self.app_key[$SOCIAL_LOGINS_DATA.[$self.service].app_key]
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
@get_current_user[hParams]
	^hParams.add[
		$.application_key[$self.app_key]
		$.format[json]
		$.method[users.getCurrentUser]
	]
	^hParams.add[
		$.sig[^self.sig[$hParams]]
	]
	$result[^load[POST;$self.get_current_user_url;$hParams;json]]
#end @get_current_user[]



##############################################################################
@load[sMethod;sUrl;hParams;sResultType]
	$params[
		$.body[^hash::create[$hParams]]
	]
	$params.method[$sMethod]

	$result[^_load_curl[$sUrl;$params;$sResultType]]
#end @load[]



##############################################################################
@sig[hParams]
	$params[^sort_hash_by_key[^hash::create[$hParams]]]
	$md5key[^math:md5[${hParams.access_token}$self.app_secret]]
	$result[^math:md5[^params.foreach[key;value]{^if($key ne "access_token"){${key}=${value}}}$md5key]]
#end @sig[]