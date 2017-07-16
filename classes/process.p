##############################################################################
#	
##############################################################################

@CLASS
Process

@OPTIONS
locals

@BASE
WebController



##############################################################################
@_process_file_name[sProcess]
	$result[^string_transform[$sProcess;decode]_process.p]
#end @_process_file_name[]



##############################################################################
@_process_class_name[sProcess]
	$result[^string_transform[$sProcess]Process]
#end @_process_class_name[]



##############################################################################
@GET_DEFAULT[sName]
	^if($sName ne "_context"){
		$result[$self._context.[$sName]]
	}{
		$result[]
	}
#end @GET_DEFAULT[]



##############################################################################
@create[oContext]
	$self._context[^if($oContext){$oContext}{$caller.self}]
	
	^BASE:create[]
#end @create[]



##############################################################################
@execute[]
	
#end @execute[]