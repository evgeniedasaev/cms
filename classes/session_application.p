##############################################################################
#	
##############################################################################

@CLASS
SessionApplication

@OPTIONS
partial
locals

@BASE
TransactionWebController



##############################################################################
@auto[]
	$self.SESSION_TIMEOUT(30)													^rem{ *** время жизни сессии в минутах *** }
	$self.CID_TIMEOUT(90 * 24 * 60)												^rem{ *** время выдачи CID в минутах *** }
#end @auto[]



##############################################################################
@create[]
	^BASE:create[]
	
	^before_filter[session_start]												^rem{ *** инициализация сессии *** }
#end @create[]



##############################################################################
@authenticate[]
	^if($self.oUser.isGuest){
		^redirect_to[^named_url_for[logon]]
	}
#end @authenticate[]



##############################################################################
#	Метод инициализирует сессию и пользователя по $cookie:sid & $cookie:uid
#	Если пользователь не проявлял активность более SESSION_TIMEOUT минут,
#	то происходит обновление сессии c сохранением связи с пользователем
##############################################################################
@session_start[]
	$now[^date::now[]]
	$dt_timeout[^date::now(-$self.SESSION_TIMEOUT / (24 * 60))]
	$dt_cid_timeout[^date::now(-$self.CID_TIMEOUT / (24 * 60))]

	^oSql.transaction{
		^if(def $cookie:uid){
			^if(!^oSql.get_lock[session/$cookie:uid](10)){
				^throw_inspect[LOCK for "session/$cookie:uid" not ocurre]
			}
		}
	
		^if(def $cookie:sid){
			$session[^Session:find_by_sid[$cookie:sid]]
		}
		
		$is_bot(def $env:HTTP_USER_AGENT && ^env:HTTP_USER_AGENT.match[bot])
		
		^rem{ *** для ботов инициализируем сессии не по UID *** }
		^if(!$session && $is_bot){
			$session_key[/session/^Session:cryptUserAgent[$env:HTTP_USER_AGENT]/^math:md5[${env:REMOTE_ADDR}^if(def $env:HTTP_X_FORWARDED_FOR){:${env:HTTP_X_FORWARDED_FOR}}]]
			$session_id[$self.oMemcached.[$session_key]]
			
			^if(^session_id.int(0)){
				$session[^Session:find_by_id($session_id)]
			}
			
			^if(!$session){
				$session[^Session:find_by_user_agent_hash[^Session:cryptUserAgent[$env:HTTP_USER_AGENT]][
					$.condition[
						remote_addr = "$env:REMOTE_ADDR" AND
						forwarded_for ^if(def $env:HTTP_X_FORWARDED_FOR){ = "$env:HTTP_X_FORWARDED_FOR"}{IS NULL} AND
						dt_access >= "^dt_timeout.sql-string[]"
					]
					$.order[dt_access DESC]
				]]
				
				$self.oMemcached.[$session_key][
					$.value[$session.id]
					$.expires(7 * 24 * 60 * 60)
				]
			}
		}

		^if(!$session){
			$session[^init_session[]]											^rem{ *** инициализируем новую сессию *** }
		}($is_bot){
			^rem{ *** для ботов пропускаем проверку UID *** }
		}(!def $cookie:uid || $session.uid ne $cookie:uid){						^rem{ *** если пользователь в сессии не совпадает *** }
			$session[^init_session[]]											^rem{ *** инициируем новую сессию *** }
		}
	
		$user[$session.user.object]												^rem{ *** Обязательно .object иначе следующий User.merge приведет к удалению самого пользователя *** }
		^if(!$user){
			$user[^Guest::create[]]												^rem{ *** инициируем Анонимного пользователя *** }
			$session.user[$user]
		}
		
		^if(!$session.cid){
			$cid[^init_cid[]]
			$session.cid[$cid.cid]
		}
		
		^rem{ *** если сессия не активная более CID_TIMEOUT = выдаем новый CID, т.к. старый уже будет просрочен *** }
		^if($session && $session.dt_access && ^date::create($session.dt_access) < $dt_cid_timeout){
			$cid[^init_cid[]]
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
			$_cid[$session.cid]													^rem{ *** сохраняем cid для его продолжения *** }

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
				$session[^init_session[]]
			}

			$session.user[$user]												^rem{ *** сохраняем связь с пользователем *** }
			$session.cid[$_cid]													^rem{ *** вставляем тот же cid = продолжаем *** }
		}

		^if($session.dt_access <= ^date::now(- 15 / (24 * 60 * 60))){
			$session.dt_access[$now]											^rem{ *** обновить dt_access раз в 15 секунд *** }
		}
	
		^rem{ *** пытаемся обновить сессию *** }
		^if(!^session.save[]){
			^throw_inspect[^session.errors.array[]]
		}
		^if(!^user.save[]){
			^throw_inspect[^user.errors.array[]]
		}
	
		^rem{ *** БЕЗ ЭТОГО РЕЛИЗА ВСЕ ПОТОКИ БУДУТ ВЫСТРАИВАТЬСЯ В ОЧЕРЕДЬ ДО ЗАВЕРШЕНИЯ *** }
		^if(def $cookie:uid){
			^if(^oSql.release_lock[session/$cookie:uid]){}
		}
	}
	
	^rem{ *** записываем в cookie SID сессии & UID *** }
	$cookie:sid[$session.sid]
	$cookie:uid[$session.uid]

	$self.oSession[$session]
	$self.oUser[$user]
#end @session_start[]



##############################################################################
@logon[sLogin;sPassword]
	$user[^Employee:published[]]
	$user[^user.find_first[
		$.condition[name = "$sLogin" AND passwd = "^User:cryptPassword[$sPassword]"]
	]]

	^self.logon_by_user[$user]
#end @logon[]



##############################################################################
@logon_person[sLogin;sPassword]
	$user[^Person:published[]]
	$user[^user.find_first[
		$.condition[name = "$sLogin" AND passwd = "^User:cryptPassword[$sPassword]"]
	]]

	^self.logon_by_user[$user]
#end @logon_person[]



##############################################################################
@logon_by_user[user]
	^if($user){
		^if($self.oUser.isGuest){
			^user.merge[$self.oUser]											^rem{ *** объединение пользователей *** }
		}

		$self.oSession.user[$user]												^rem{ *** привязываем пользователя к сессии *** }
		$self.oUser[$user]
	
		^if(!^self.oSession.save[]){
			^throw_inspect[^self.oSession.errors.array[]]
		}
	}
#end @logon_by_user[]



##############################################################################
@logout[]
	$session[^init_session[]]

	$user[^Guest::create[]]														^rem{ *** теперь пользователь гость *** }
	$session.user[$user]
	
	$cid[^init_cid[]]															^rem{ *** выделяем новый cid *** }
	$session.cid[$cid.cid]

	^if(!^session.save[]){
		^throw_inspect[^session.errors.array[]]
	}
	^if(!^user.save[]){
		^throw_inspect[^user.errors.array[]]
	}
	
	^rem{ *** записываем в cookie SID сессии & UID *** }
	$cookie:sid[$session.sid]
	$cookie:uid[$session.uid]	

	$self.oSession[$session]
	$self.oUser[$user]
#end @logout[]




##############################################################################
@init_session[]
	$result[^Session::create[
		$.uid[$cookie:uid]
		$.remote_addr[$env:REMOTE_ADDR]
		$.forwarded_for[$env:HTTP_X_FORWARDED_FOR]
		$.user_agent_hash[^Session:cryptUserAgent[$env:HTTP_USER_AGENT]]
	]]
#end @init_session[]



##############################################################################
@init_cid[]
	^if(!^oSql.get_lock[cid](10)){
		^throw_inspect[LOCK for "cid" not ocurre]
	}

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
	
	^if(^oSql.release_lock[cid]){}
	
	$result[$cid]
#end @init_cid[]
