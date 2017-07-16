##############################################################################
# Общая модель для очередей
##############################################################################

@CLASS
QueueModel

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]
	
	$self.STATUSES[^enum::create[	^rem{*** Доступные статусы задач в очереди ***}
		$.in_progress[
			$.id(0)
			$.code[in_progress]
			$.name[Выполняется]
		]
		$.pause[
			$.id(10)
			$.code[pause]
			$.name[Остановлено]
		]
	]]

	^rem{*** поля ***}
	^field[status][					^rem{*** Статус задачи ***}
		$.type[string]
	]
	^field[retry_time][				^rem{*** Кол-во попыток запуска задачи ***}
		$.type[int]
	]
	^field[dt_start][				^rem{*** Время запуска задачи в очереди ***}
		$.type[date]
	]
	^field[dt_create][				^rem{*** Время создания задачи в очереди ***}
		$.type[date]
	]
	^field[dt_update][				^rem{*** Время обновления задачи в очереди ***}
		$.type[date]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}

	^rem{*** ассоциации ***}	

	^rem{*** скоупы ***}
	^scope[active][
		$.condition[status = 'in_progress']
	]
	^scope[paused][
		$.condition[status = 'pause']
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.dt_create){
		$self.dt_create[^date::now[]]
	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]
#end @before_save[]



##############################################################################
@GET_is_in_progress[]
	$result($self.status eq $self.CLASS.STATUSES.in_progress.code)
#end @GET_is_in_progress[]



##############################################################################
@GET_is_pause[]
	$result($self.status eq $self.CLASS.STATUSES.pause.code)
#end @GET_is_pause[]



##############################################################################
#	Метод, который либо ищет запись по ID, либо создает новый объект модели
##############################################################################
@static:find_or_create[hOptions]
	^if(^hOptions.id.int(0)){
		$result[^self.find($hOptions.id)]
	}

	^if(!def $result){
		$result[^reflection:create[$self.CLASS_NAME;create]]
	}
#end @static:find_or_create[]



##############################################################################
#	Запуск очереди
##############################################################################
@static:run_queue[hOptions]
	^self.__update_queue[in_progress;$hOptions]
#end @static:run[]



##############################################################################
#	Обновление очереди
##############################################################################
@static:update_queue[hData;hConditions]
	$res(^self.update_all[$hData;$hConditions])
#end @static:update[]



##############################################################################
#	Остановка очереди
##############################################################################
@static:stop_queue[hConditions]
	$res(^self.update_all[
     	$.status[$self.CLASS.STATUSES.pause.code]
	][$hConditions])
#end @static:stop[]



##############################################################################
#	Обновление задачи в очереди
##############################################################################
@static:__update_queue[sStatus;hOptions]
	$hOptions[^hash::create[$hOptions]]
	
	$task[^self.find_or_create[$hOptions]]
	$task.status[$self.STATUSES.in_progress.code]

	^if(def $hOptions){
		^task.update[$hOptions]
	}

	^if(!^task.save[]){
		^throw_inspect[^task.errors.array[]]
	}
#end @static:__update_queue[]