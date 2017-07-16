##############################################################################
# Класс используется для построения seo-текстов и содержимого meta-тегов
##############################################################################

@CLASS
PGSignature



##############################################################################
# Создание подписи
##############################################################################
@static:make[sSript;hParams;sSecretKey]
	$hParams[^hash::create[$hParams]]

	$arrFlatParams[^self.__makeFlatParamsArray[$hParams]]
	
	$result[^math:md5[^self.__makeSigStr[$sSript;$arrFlatParams;$sSecretKey]]]
#end @make[]



##############################################################################
# Верификация подписи
##############################################################################
@static:check[sSignature;sSript;hParams;sSecretKey]
	$result($sSignature eq ^self.make[$sSript;$hParams;$sSecretKey])
#end @check[]


##############################################################################
# Преобразование входных параметров в дерево
##############################################################################
@static:__makeFlatParamsArray[hParams;parent_name]
	$result[^hash::create[]]
	$i(0)

	$hParams[^hash::create[$hParams]]
	^hParams.sub[
		$.controller(true)
		$.action(true)
		$.pg_sig(true)
	]
	^if($hParams){
		^hParams.foreach[key;value]{
			^i.inc[]

			^rem{*** 
				Имя делаем вида tag001subtag001
				Чтобы можно было потом нормально отсортировать и вложенные узлы не запутались при сортировке
			 ***}

			$name[${parent_name}${key}^eval($i)[%03.0f]]

			^if($value is hash){
				$hFlatValue[^self.makeFlatParamsArray[$value;$name]]
				^if($hFlatValue){
					^hFlatValue.foreach[valueKey;valueValue]{
						$result.[$valueKey][$valueValue]
					}
				}

				^continue[]
			}

			$result.[$name][$value]
		}
	}
#end @static:__makeFlatParamsArray[]



##############################################################################
# Построение подписи
##############################################################################
@static:__makeSigStr[sScript;hParams;sSecretKey]
 	$hParams[^hash::create[$hParams]]
 	^hParams.sort[name;]{$name} 

	$result[^array::create[]]

 	^hParams.foreach[key;value]{
 		^if($key eq 'pg_sig'){ ^continue[]	}

 		^result.add[$value]
 	}

 	^result.add[$sSecretKey]

 	$result[${sScript}^foreach[$result;value]{^;$value}]
#end @static:__makeSigStr[]
