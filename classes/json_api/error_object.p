##############################################################################
#	
##############################################################################

@CLASS
ErrorObject

@OPTIONS
locals



##############################################################################
@create[hParams]
    $hParams[^hash::create[$hParams]]
    
    ^if(def $hParams.status){
        $self._status[$hParams.status]
    }
    ^if(def $hParams.title){
        $self._title[$hParams.title]
    }
    ^if(def $hParams.resource){
        $self._resource[$hParams.resource]
    }
    ^if(def $hParams.details){
        $self._details[$hParams.details]
    }
#end @create[]



##############################################################################
@static:json[key;error_object;options]
    $result[^json:string[
        ^if(def $error_object._status){
            $.status[$error_object._status]
        }
        ^if(def $error_object._title){
            $.title[$error_object._title]
        }
        ^if(def $error_object._resource){
            $.resource[$error_object._resource]
        }
        ^if(def $error_object._details){
            $.details[$error_object._details]
        }
    ][$options]]
#end @static:json[]