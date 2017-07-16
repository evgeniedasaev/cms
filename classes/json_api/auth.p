##############################################################################
#	
##############################################################################

@CLASS
Auth

@OPTIONS
locals



##############################################################################
@create[sTokean]	
	^rem{ *** время жизни сессии в минутах *** }
	$self.SESSION_TIMEOUT(30)

    ^rem{ *** время выдачи CID в минутах *** }
	$self.CID_TIMEOUT(90 * 24 * 60)

	$now[^date::now[]]
	$dt_timeout[^date::now(-$self.SESSION_TIMEOUT / (24 * 60))]
	$dt_cid_timeout[^date::now(-$self.CID_TIMEOUT / (24 * 60))]
    
	^rem{*** TODO: Начало транзакции ***}
	
        ^rem{ *** если передан токен, то ищем сессию по токену *** }
		^if(def $sTokean){
			$session[^Session:find_by_sid[$sTokean]]
		}{
			$session[^self.__init_session[]]
		}
	
        ^rem{ *** обязательно .object иначе следующий User.merge приведет к удалению самого пользователя *** }
		$user[$session.user.object]
		
        ^rem{ *** инициируем Анонимного пользователя *** }
        ^if(!$user){
			$user[^Guest::create[]]
			$session.user[$user]
		}
		
		^if(!$session.cid){
			$cid[^self.__init_cid[]]
			$session.cid[$cid.cid]
		}
		
		^rem{ *** если сессия не активная более CID_TIMEOUT = выдаем новый CID, т.к. старый уже будет просрочен *** }
		^if($session && $session.dt_access && ^date::create($session.dt_access) < $dt_cid_timeout){
			$cid[^self.__init_cid[]]
			$session.cid[$cid.cid]
		}
	
		^rem{ *** если изменился IP или сессия просрочена *** }
		^if($session &&
			(
				$session.remote_addr ne "$env:REMOTE_ADDR" ||
				$session.forwarded_for ne "$env:HTTP_X_FORWARDED_FOR" ||
				$session.user_agent_hash ne "^Session:cryptUserAgent[$env:HTTP_USER_AGENT]" ||
				($session.dt_access && ^date::create($session.dt_access) < $dt_timeout)
			)
		){
            ^rem{ *** сохраняем cid для его продолжения *** }
			$_cid[$session.cid]

			^rem{ *** пробуем найти активную сессию для пользователя или инициируем новую *** }
			$session[^Session:find_by_uid[$session.uid][
				$.condition[
					remote_addr = "$env:REMOTE_ADDR" AND
					forwarded_for ^if(def $env:HTTP_X_FORWARDED_FOR){ = "$env:HTTP_X_FORWARDED_FOR"}{IS NULL} AND
					user_agent_hash = "^Session:cryptUserAgent[$env:HTTP_USER_AGENT]" AND
					dt_access >= "^dt_timeout.sql-string[]"
				]
				$.order[dt_access DESC]
			]]
			^if(!$session){
				$session[^self.__init_session[]]
			}

            ^rem{ *** сохраняем связь с пользователем *** }
			$session.user[$user]

            ^rem{ *** вставляем тот же cid = продолжаем *** }
			$session.cid[$_cid]
		}

        ^rem{ *** обновить dt_access раз в 15 секунд *** }
		^if($session.dt_access <= ^date::now(- 15 / (24 * 60 * 60))){
			$session.dt_access[$now]
		}
	
		^rem{ *** пытаемся обновить сессию *** }
		^if(!^session.save[]){
			^throw_inspect[^session.errors.array[]]
		}
		^if(!^user.save[]){
			^throw_inspect[^user.errors.array[]]
		}

	^rem{*** TODO: Конец транзакции ***}

	$self._session[$session]
	$self._user[$user]
#end @create[]



##############################################################################
@GET_session[]
    $result[$self._session]
#end @GET_session[]



##############################################################################
@GET_user[]
    $result[$self._user]
#end @GET_user[]



##############################################################################
@logon[sLogin;sPassword]
    $user[^Employee:published[]]
	$user[^user.find_first[
		$.condition[name = "$sLogin" AND passwd = "^User:cryptPassword[$sPassword]"]
	]]
    
    ^rem{ *** привязываем пользователя к сессии *** }
    ^if($user){
		$self._session.user[$user]
		$self._user[$user]
	
		^if(!^self._session.save[]){
			^throw_inspect[^self._session.errors.array[]]
		}
	}
#end @logon[]



##############################################################################
@logout[]
	^rem{ *** теперь пользователь гость *** }
	$user[^Guest::create[]]
	$self._session.user[$user]
	
    ^rem{ *** выделяем новый cid *** }
	$cid[^self.__init_cid[]]
	$self._session.cid[$cid__.cid]

	^if(^user.save[]){		
		^if(!^self._session.save[]){
			^throw_inspect[^self._session.errors.array[]]
		}
	}{
		^throw_inspect[^user.errors.array[]]
	}

	$self._user[$user]
#end @logout[]




##############################################################################
@__init_session[]
	$result[^Session::create[
		$.uid[$cookie:uid]
		$.remote_addr[$env:REMOTE_ADDR]
		$.forwarded_for[$env:HTTP_X_FORWARDED_FOR]
		$.user_agent_hash[^Session:cryptUserAgent[$env:HTTP_USER_AGENT]]
	]]
#end @__init_session[]



##############################################################################
@__init_cid[]
^rem{***	^if(!^self.oSql.get_lock[cid](10)){
		^throw_inspect[LOCK for "cid" not ocurre]
	}***}

	$cid[^UserCID:free[]]
	$cid[^cid.first[]]
	
	^if(!$cid){
		^throw_inspect[no empty CID]
	}
	
	^rem{ *** блокируем  *** }
	$cid.is_free(false)
	^if(!^cid.save[]){
		^throw_inspect[^cid.errors.array[]]
	}
	
^rem{***	^if(^self.oSql.release_lock[cid]){}***}
	
	$result[$cid]
#end @__init_cid[]
