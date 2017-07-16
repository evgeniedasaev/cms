##############################################################################
#	Хранилище кеша в memcache
#	сохраняет результат и заголовки
##############################################################################

@CLASS
WebMemcacheStore

@OPTIONS
locals

@BASE
MemcacheStore



##############################################################################
@cache[sPath;uTime;jCode]
	^if(!def $uTime){
		$uTime[$self._time]
	}
	
#	$result[^self._memcached.mget]
	
	$key[^self.key[${self.path}/${sPath}]]
	$result[$self._memcached.[$key]]

	^if(!def $result){
		^while(!^self._memcached.add[${key}-lock][
			$.value[$self._timeout]
			$.expires($self._timeout)
		]){
			^for[i](1;$self._timeout * 5){ 
				^sleep(0.2)
				$result[$self._memcached.[$key]]
				^if(def $result){^break[]}
			}
		
			^if(def $result){ 
				^break[]
			}{
				^if(!$self._retry_on_timeout){ 
					^throw[$self.CLASS_NAME;Timeout while getting lock for key '$key']
				}
			}
		}
	}
	^if(!def $result){
		^try{
			$result[$jCode]			
			$self._memcached.[$key][
				$.value[^serialize[$result]]
				$.expires($uTime)
			]
		}{
			
		}{
			^self._memcached.delete[${key}-lock]
		}
	}{
		$result[^unserialize[$result]]
	}
#end @cache[]


##############################################################################
@serialize[sResult]
	$sHeaders[^json:string[$response:headers]]
	$sHeaderLength[^eval(^sHeaders.length[])[%010u]]
	$result[${sHeaderLength}${sHeaders}${sResult}]
#end @serialize[]



##############################################################################
@unserialize[sData]
	$iLength(^sData.left(10))
	$sHeaders[^sData.mid(10;$iLength)]
	$sResult[^sData.mid(10 + $iLength)]
	
	$headers[^json:parse[$sHeaders][
#		$.object[$self.json_handler]
#		$.array[$self.json_handler]
		$.taint[as-is]
	]]
	^if(def $headers.[last-modified]){
		$headers.[last-modified][^dtf:create[$headers.[last-modified]]]
	}
#	^throw_inspect[$headers.last-modified.CLASS_NAME]
	^headers.foreach[k;v]{
		$response:[$k][$v]
	}
	$result[$sResult]
#end @unserialize[]
