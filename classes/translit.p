##############################################################################
#
##############################################################################

@CLASS
Translit



##############################################################################
@translit_string[sString]
	$result[^sString.replace[^table::load[nameless;$CONFIG:sLibPath/translit.cfg]]]
#end @translit_string[]