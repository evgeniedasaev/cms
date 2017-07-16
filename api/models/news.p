##############################################################################
#
##############################################################################

@CLASS
News

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[object_id][
		$.type[int]
	]
	^field[type_id][
		$.name[news_type_id]
		$.type[int]
	]
	^field[template_id][
		$.type[int]
	]
	^field[header][
		$.type[string]
	]
	^field[lead][
		$.type[string]
	]
	^field[url][
		$.type[string]
	]
	^field[body][
		$.type[string]
	]
	^field[dt][
		$.type[date]
	]
	^field[dt_create][
		$.type[date]
	]
	^field[dt_update][
		$.type[date]
		$.is_protected(true)
	]
	^field[is_published][
		$.type[bool]
	]

	^validates_presence_of[header]
	^validates_presence_of[url][
		$.on[update]
	]
	^validates_presence_of[dt]

	^scope[published][
		$.condition[is_published = 1]
	]
	^scope[sorted_for_public][
		$.order[dt DESC]
	]
	^scope[sorted][
		$.order[dt_create DESC, dt DESC]
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.dt_create){
		$self.dt_create[^date::now[]]
	}

	^if(!def $self.url){
		^rem{ *** генерируем url путем транслита названия и удаления запрещенных символов *** }
		$self.url[^Urlify:urlify[$self.header]]
	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]

	^if(!def $self.dt){
		$self.dt[^date::now[]]
	}
#end @before_save[]



##############################################################################
@get_calendar[oCriteria]
	$query[^oSqlBuilder.select[]]

	^query.column[year][YEAR(dt_create)]
	^query.column[month][MONTH(dt_create)]
#	^query.column[day][DAY(dt_create)]
	^query.column[news][COUNT(dt_create)]

	^query.from[$self.table_name]

	^query.group[year]
	^query.group[month]
#	^query.group[day]

	^query.order[year DESC, month DESC]

	^query.merge[$oCriteria]

	$result[^query.execute[]]

	$result[^result.hash[year][ $.type[table] $.distinct(true) ]]
	^foreach[$result;year]{
		$result.[$year.year][^year.hash[month;news][ $.type[string] ]]
	}
#end @get_calendar[]
