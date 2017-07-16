##############################################################################
#	Функция возвращает время публикации комментария
##############################################################################
@printDateHumane[dt;show_time;utc_offset][diff]
	$now[^date::now[]]

	$diff($now - $dt)
	
	$time[${dt.hour}:^dt.minute.format[%02.0f]]
	^if(!^show_time.bool(true) || $time eq "0:00" || $time eq "23:59"){$time[]}

	$result[^dt.day.format[%02.0f] $dtf:rr-locale.month.[$dt.month] ${dt.year}]
	$result[$dtf:ri-locale.weekday.[$dt.weekday], ^result.lower[]^if(def $time){ $time}]

	^if($now.year == $dt.year){
		^if($now.month == $dt.month){
			^if($now.day == $dt.day){
				$result[Сегодня^if(def $time){, $time}]
			}
			^if($now.day - 1 == $dt.day){
				$result[Вчера^if(def $time){, $time}]
			}
			^if($now.day + 1 == $dt.day){
				$result[Завтра^if(def $time){, $time}]
			}
		}
	}
#end @printDateHumane[]



##############################################################################
@printDatePeriodHumane[dt]
	
#end @printDatePeriodHumane[]



##############################################################################
#	Функция возвращает время публикации комментария
##############################################################################
@printFixedDateHumane[dt;show_time;utc_offset][diff]
	$now[^date::now[]]

	$diff($now - $dt)
	
	$time[${dt.hour}:^dt.minute.format[%02.0f]]
	^if(!^show_time.bool(true) || $time eq "0:00" || $time eq "23:59"){$time[]}

	$result[^dt.day.format[%02.0f] $dtf:rs-locale.month.[$dt.month]]
	$result[$dtf:rs-locale.weekday.[$dt.weekday], ^result.lower[]^if(def $time){ $time}]

	^if($now.year == $dt.year){
		^if($now.month == $dt.month){
			^if($now.day == $dt.day){
				$result[Сегодня^if(def $time){, $time}]
			}
			^if($now.day - 1 == $dt.day ){
				$result[Вчера^if(def $time){, $time}]
			}
			^if($now.day + 1 == $dt.day){
				$result[Завтра^if(def $time){, $time}]
			}
		}
	}
#end @printFixedDateHumane[]



##############################################################################
@printTimeDateHumane[time]
	$days[^math:floor($time / 60 / 24)]
	$hours[^math:floor($time % (24 * 60) / 60)]
	$minutes($time % 60)

	$result[^if($days){${days}д }^if($hours){${hours}ч }^if($minutes){${minutes}м}]
#end @printTimeDateHumane[]



##############################################################################
#	Возвращает время в формате 00ч 00мин получая в минутах
##############################################################################
@printTimeHumane[time]
	$hours[^math:floor($time / 60)]
	$minutes($time % 60)

	$result[^if($hours){${hours}ч }^if($minutes){${minutes}м}]
#end @printTimeHumane[]



##############################################################################
@printTime[time]
	$hours[^math:floor($time / 60)]
	$minutes($time % 60)
	
	$result[^eval($hours)[%01.0f]:^eval($minutes)[%02.0f]]
#end @printTime[]



##############################################################################
#	Функция вывода прошедшего времени с даты
##############################################################################
@printTimeLeftHumane[dt]
	$now[^date::now[]]
	$diff($now - $dt)
	
	^if($dt.year != $now.year && $dt.hour == 23 && $dt.minute == 59 && $dt.second == 59){
		$result[^dtf:format[%d %b %Y][$dt]]
	}($dt.year != $now.year){
		$result[^dtf:format[%d %b %Y, %H:%M][$dt]]
	}($diff >= 7 && $dt.hour == 23 && $dt.minute == 59 && $dt.second == 59){
		$result[^dtf:format[%d %b][$dt]]
	}($diff >= 7){
		$result[^dtf:format[%d %b, %H:%M][$dt]]
	}($diff >= 365){
		$years($diff \ 365)
		$result[более $years ^num_decline[$years][года;лет;лет] назад]
	}($diff > 30){
		$months($diff \ 30)
		^if($diff / 30 % 1 > 0.5){
			^months.inc[]
			$result[около $months ^num_decline[$months][месяца;месяцев;месяцев] назад]
		}{
			$result[^if($months > 1){$months }^num_decline[$months][месяц;месяца;месяцев] назад]
		}
	}($diff >= 1){
		$days($diff \ 1)
		$result[^if($days > 1){$days }^num_decline[$days][день;дня;дней] назад]
	}($diff * 24 >= 1){
		$hours($diff * 24 \ 1)
		^if($diff * 24 % 1 > 0.5){
			^hours.inc[]
			$result[около $hours ^num_decline[$hours][часа;часов;часов] назад]
		}{
			$result[^if($hours > 1){$hours }^num_decline[$hours][час;часа;часов] назад]
		}
	}($diff * 24 * 60 >= 1){
		$minutes($diff * 24 * 60 \ 1)
		$result[^if($minutes > 1){$minutes }^num_decline[$minutes][минуту;минуты;минут] назад]
	}{
		$result[только что]
	}
		
#	$result[$result = ^eval($diff)[%f] = ^eval($diff * 24)[%f] = ^eval($diff * 24 * 60)[%f]]
#end @printTimeLeftHumane[]



##############################################################################
#	Возвращает дату начала следующей недели
#	TODO: добавить определение первого дня недели в зависимости от страны
##############################################################################
@get_next_week[dNow]
	^if($dNow.weekday == 0){
		$result[^date::now(1)]
	}{
		$result[^date::now(7 - $dNow.weekday + 1)]
	}
	$result[^date::create($result.year;$result.month;$result.day)]
#end @get_next_week[]



##############################################################################
#	Функция возвращает dDt с учетом того что она указана в sTZ таймзоне
##############################################################################
@set_dt_tz[dDt;sTZ]
	$result[^date::create[$dDt]]

	^if(def $sTZ){
		^rem{ *** roll to timezone (if not specified -- roll to GMT as offset is GMT-related) *** }
		$dt[^date::create[$result]]
		^dt.roll[TZ;$sTZ]
		
		$iDiff(^date::create($dt.year;$dt.month;$dt.day;$dt.hour;$dt.minute;$dt.second) - $result)
		$result[^date::create($dt - $iDiff)]
	}
#	^if(def $h.offset.hour){
#		^rem{ *** apply timezone offset *** }
#		$result[^date::create($result - (^h.offset.hour.int(0) + ^h.offset.minute.int(0) / 60) / 24)]
#	}

	^rem{ *** apply DST offset *** }
	^if($result.daylightsaving){
		$result[^date::create($result + $result.daylightsaving / 24)]
	}
#end @set_dt_tz[]