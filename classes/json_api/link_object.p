##############################################################################
#	
##############################################################################

@CLASS
LinkObject

@OPTIONS
locals



##############################################################################
@create[sEndpoint;sMethod;hParams]
    $self._endpoint[$sEndpoint]
    $self._method[$sMethod]
    $self._params[^deep_clone[$hParams]]
#end @create[]



##############################################################################
@static:json[key;link_object;options]
    $result[^json:string[
        $.endpoint[$link_object._endpoint]
        $.method[$link_object._method]
        $.params[$link_object._params]
    ][$options]]
#end @static:json[]