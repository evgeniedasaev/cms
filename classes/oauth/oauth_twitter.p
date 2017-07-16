##############################################################################
#
##############################################################################

@CLASS
OAuthTwitter

@OPTIONS
locals

@BASE
OAuthBase



##############################################################################
@auto[]
	$self.service[$SocialLogin:TYPES.tw.code]
	$self.request_token_url[https://api.twitter.com/oauth/request_token]
	$self.access_token_url[https://api.twitter.com/oauth/access_token]
	$self.authenticate_url[https://api.twitter.com/oauth/authenticate]
	$self.verify_credentials_url[https://api.twitter.com/1.1/account/verify_credentials.json]

	$self.api_key[$SOCIAL_LOGINS_DATA.[$self.service].api_key]
	$self.api_secret[$SOCIAL_LOGINS_DATA.[$self.service].api_secret]
#end @auto[]



##############################################################################
@request_token[hAuthParams]
	$result[^load[POST;$self.request_token_url;$hAuthParams]]
#end @request_token[]



##############################################################################
@access_token[hAuthParams;hParams]
	$result[^load[POST;$self.access_token_url;$hAuthParams;$hParams]]
#end @access_token[]



##############################################################################
@verify_credentials[hAuthParams;hParams;sTokenSecret]
	$result[^load[GET;$self.verify_credentials_url;$hAuthParams;$hParams;$sTokenSecret;json]]
#end @verify_credentials[]



##############################################################################
@load[sMethod;sUrl;hAuthParams;hParams;sTokenSecret;sResultType]
	$params[
		$.body[^hash::create[$hParams]]
	]

	$params.headers[
		$.Authorization[^oauth_authorization[$sMethod;$sUrl;$hAuthParams;$params.body;$sTokenSecret]]
	]
	$params.method[$sMethod]

	$result[^_load_curl[$sUrl;$params;$sResultType]]
#end @load[]



##############################################################################
@oauth_authorization[sMethod;sUrl;hAuthParams;hParams;sTokenSecret]
	$now[^date::now[]]

	^hAuthParams.add[
		$.oauth_consumer_key[$self.api_key]
		$.oauth_nonce[^math:uid64[]]
		$.oauth_signature_method[HMAC-SHA1]
		$.oauth_timestamp[^now.unix-timestamp[]]
		$.oauth_version[1.0]
	]

	$hAuthParams.oauth_signature[^oauth_signature[$sMethod;$sUrl;$sTokenSecret;^hAuthParams.union[$hParams]]]

	$hAuthParams[^sort_hash_by_key[^percent_encode_hash[$hAuthParams]]]

	$result[OAuth ^hAuthParams.foreach[key;value]{${key}=${value}}[, ]]
#end @oauth_authorization[]



##############################################################################
@oauth_signature[sMethod;sUrl;sTokenSecret;hParams]
	$params[^sort_hash_by_key[^percent_encode_hash[^hash::create[$hParams]]]]
	$parameter_string[^params.foreach[key;value]{${key}=${value}}[&]]
	$signature_base_string[^sMethod.upper[]&^percent_encode_string[$sUrl]&^percent_encode_string[$parameter_string]]
	$signing_key[^percent_encode_string[$self.api_secret]&^percent_encode_string[$sTokenSecret]]
	$result[^math:digest[sha1;$signature_base_string][
		$.format[base64]
		$.hmac[$signing_key]
	]]
#end @oauth_signature[]