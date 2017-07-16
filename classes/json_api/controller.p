##############################################################################
#
##############################################################################

@CLASS
JsonApiController

@USE
json_api/auth.p
json_api/json_api.p

@OPTIONS
locals

@BASE
TransactionWebController



##############################################################################
@create[]
	^BASE:create[]

	^rem{ *** подключаем хелперы *** }
	^include_helpers[*]

	^rem{***
	^cache_action[index][
		$.time(60 * 60)
		$.key_generator[cache_key]
	]
	***}
	
	^rem{*** определяем MEDIA_TYPE для ответа ***}
	^before_filter[define_media_type]
	
	^rem{*** инициилизируем json_data ***}
	^before_filter[define_json_data]
	
	^rem{*** парсим параметры JSON API ***}
	^before_filter[define_api_params]
	
	^rem{*** инициируем доступ ***}
	^before_filter[define_user_session]
	
	^rem{*** подключаем ACL для поверки прав доступа к разделам ***}
	^before_filter[define_acl]
	
	^rem{*** определяем хэш с правами ***}
	^before_filter[define_user_rights]
#end @create[]



##############################################################################
@cache_key[]
	$result[api/$params.action/^math:md5[^taint[as-is][$request:body]]]]]
#end @cache_key[]



##############################################################################
@define_media_type[]
	$params.format[json]

	$self.MEDIA_TYPE[application/vnd.api+json]

	^MAIN:MIME-TYPES.append{json	$self.MEDIA_TYPE}
#end @define_media_type[]



##############################################################################
@define_json_data[]
	$self.json_data[
		$.operations[^hash::create[]]
		$.errors[^array::create[]]
	]
#end @define_json_data[]



##############################################################################
@define_api_params[]
	^try{
		$self.api_params[^json:parse[^taint[as-is][$request:body]]]
	}{
		$self.api_params[^hash::create[]]
		
		^self.json_data.errors.add[^ErrorObject::create[
			$.status[403]
			$.title[request_wrong_format]
			$.details[$exception.comment]
		]]
		
		$exception.handled(true)
	}
#end @define_api_params[]



##############################################################################
@define_user_session[]
	$auth[^Auth::create[$self.api_params.tokean]]
	
	$self.oSession[$auth.session]
	$self.oUser[$auth.user]
#end @define_user_session[]



##############################################################################
@define_acl[]
	$self.oACL[^UserACL::create[$self.oUser]]
#end @define_acl[]



##############################################################################
@define_user_rights[]
    $self.rights[^enum::create[]]
#end @define_user_rights[]



##############################################################################
@check_access[sEndpoint;sMethod]
	$result(false)

	$model_class[^string_transform[$sEndpoint;filename_to_classname]]

	^rem{*** всегда разрешаем авторизацию и деавторизацию ***}
	^if($model_class eq 'Auth'){
		$result(true)
	}

	^rem{*** проверяем, есть ли доступ к объекту у пользователя ***}
	^if(^self.oACL.check_rights[access;$model_class]){
		$result(true)
	}

	^rem{*** проверяем, есть ли у пользователя доступ к конкретному действию над объектом ***}
	^if(
		$self.rights.[$model_class] &&
		$self.rights.[$model_class].rights && 
		^self.rights.[$model_class].rights.contains[$sMethod] && 
		^self.oACL.check_rights[$sMethod;$model_class]
	){
		$result(true)
	}
	
	$result(true)
#end @check_access[]



##############################################################################
@aIndex[]
	^if($self.api_params.operations && !$self.json_data.errors){
		^MAIN:CLASS_PATH.append{$CONFIG:sRootPath/$params.application/json_api_classes}

		^foreach[$self.api_params.operations;operation]{		
			$api_class_name[^operation.endpoint.lower[]_api]
			$api_class[^string_transform[$api_class_name;filename_to_classname]]

			^if(^check_access[$operation.endpoint;$operation.method]){
				^try{
					^use[${api_class_name}.p]
					
					$endpoint_object[^reflection:create[$api_class;create;$operation.params;$API_VERSION]]
					$endpoint_method[^reflection:method[$endpoint_object;$operation.method]]
					
					$endpoint_method_result[^endpoint_method[]]
					
					$json_data.operations.[$operation.uid][$endpoint_method_result]
				}{
					$self.api_params[^hash::create[]]
					
					^self.json_data.errors.add[^ErrorObject::create[
						$.status[403]
						$.title[request_wrong_format]
						$.details[Endpoint class ${api_class}: (${exception.source} ${exception.comment})]
					]]
					
					$exception.handled(true)
				}
			}{
				^self.json_data.errors.add[^ErrorObject::create[
					$.status[403]
					$.title[access_forbidden]
					$.details[Acess forbidden for ${api_class}:${operation.method} for user with id ^self.oUser.id.int(0)]
				]]
			}
		}
	}(!$self.api_params.operations){
		^self.json_data.errors.add[^ErrorObject::create[
			$.status[403]
			$.title[request_wrong_format]
			$.details[Operations not found in request]
		]]
	}
	
	^render[
		$.text[^JsonApi:print_json[$self.json_data]]
	]
#end @aIndex[]