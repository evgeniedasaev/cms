##############################################################################
@url_encode[sString]
	$sString[^sString.trim[]]
	$sString[^sString.match[\s+][gi]{ }]
	$sString[^sString.match[^[\*!\(\)'"\?\/^]][gi]{}]
	$result[^Translit:translit_string[^sString.lower[]]]
#end @url_encode[]



###########################################################################
@capitalize[sText]
	$sText[^sText.trim[]]
	$sText[^sText.lower[]]

	$result[^if(def $sText){^sText.match[^^(.{1})][g]{^match.1.upper[]}}]
#end of @capitalize[]
