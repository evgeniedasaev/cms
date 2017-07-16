##############################################################################
#
##############################################################################

@CLASS
OAuthBase

@OPTIONS
locals

@BASE
Environment



##############################################################################
@_load_curl[sUrl;hOptions;sResultType]
	$options[
		^if($hOptions.method eq "POST"){
			$.post(1)
		}
		^if(def $hOptions.body){
			^if($hOptions.method eq "POST"){
				$.postfields[^hOptions.body.foreach[key;value]{$key=$value}[&]]
			}{
				$sUrl[$sUrl?^hOptions.body.foreach[key;value]{$key=$value}[&]]
			}
		}
		$.url[$sUrl]
		$.httpheader[$hOptions.headers]
		$.timeout(30)
		
		$.ssl_verifypeer(0)
	]

	$result[^curl:load[$options]]

	^if($result.status != 200){
		^throw[twitter_api.$result.status;$result.text;$result.text^#0A^inspect[$hOptions]]
	}

	^if($sResultType eq "json"){
		$result[^json:parse[^taint[as-is][$result.text]]]
	}{
		$result[^response_to_hash[$result.text]]
	}
#end @_load_curl[]



##############################################################################
@percent_encode_string[sString]
	$string[^apply-taint[^taint[uri][$sString]]]
	$result[^string.replace[/;%2F]]
#end @percent_encode_string[]



##############################################################################
@percent_encode_hash[hParams]
	$result[^hash::create[]]

	^hParams.foreach[key;value]{
		$result.[^percent_encode_string[$key]][^percent_encode_string[$value]]
	}
#end @percent_encode_hash[]



##############################################################################
@sort_hash_by_key[hHash;sDirection]
	$keys[^hHash._keys[]]
	^keys.sort{$keys.key}[$sDirection]

	$result[^hash::create[]]
	^keys.menu{
		$result.[$keys.key][$hHash.[$keys.key]]
	}
#end @sort_hash_by_key[]



##############################################################################
@response_to_hash[sResponse]
	$params[^sResponse.split[&]]

	$result[^hash::create[]]

	^params.menu{
		$parts[^params.piece.split[=;h]]
		$result.[$parts.0][$parts.1]
	}
#end @response_to_hash[]