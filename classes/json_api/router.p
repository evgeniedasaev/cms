##############################################################################
#	
##############################################################################

@CLASS
JsonApiRouter

@OPTIONS
locals



##############################################################################
@create[oMap;sControllerName]
	$self._map[$oMap]
    
    ^if(def $self._map){
        ^self.__define_routes[$sControllerName]
    }
#end @create[]



##############################################################################
@__define_routes[controller_name]
	^self._map.connect[/][
		$.controller[$controller_name]
		$.action[index]
	]
#end @__define_routes[]
