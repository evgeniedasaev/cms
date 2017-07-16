##############################################################################
#
##############################################################################

@CLASS
Currency

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[code][
		$.type[string]
	]
	^field[name][
		$.type[string]
	]
	^field[sign_symbol][
		$.type[string]
	]
	^field[rate][
		$.type[double]
	]
	^field[is_base][
		$.type[bool]
	]

	^validates_presence_of[code][
		$.on[update]
	]
	^validates_uniqueness_of[code]
	^validates_presence_of[name]
	^validates_numericality_of[rate]


	^rem{ *** scopes *** }
	^scope[sorted][
		$.order[code]
	]

	^rem{ *** загружаем все валюты *** }
	$self._all_currencies_array[^self.find[
		$.order[code ASC]
	]]
	$self._all_currencies[^self._all_currencies_array.map[id]]
	$self._all_currencies_by_code[^self._all_currencies_array.map[code]]
	
	$self._all[^enum::create[^self._all_currencies_array.hash[code]]]

	^rem{ *** определяем базовую валюту *** }
	^foreach[$_all_currencies_array;cur]{
		^if($cur.is_base){
			$self._base_currency[$cur]
			^break[]
		}
	}
#end @auto[]



##############################################################################
@static:GET_ALL[]
	$result[$self._all]
#end @static:GET_ALL[]



##############################################################################
#	Все валюты в виде массива
##############################################################################
@GET_currencies[]
	$result[$self._all_currencies_array]
#end @GET_currencies[]



##############################################################################
#	Все единицы измерения для скидки (валюты + скидки) в виде хэша 
##############################################################################
@GET_curriences_for_discount[]
	$result[^array::create[]]
	^result.add[%]
	^result.join[^self.currencies.map[id;code]]
#end @GET_curriences_for_discount[]



##############################################################################
#	Хеш по всем валютам
##############################################################################
@GET_all[]
	$result[$self._all_currencies]
#end @GET_all[]



##############################################################################
#	Доступ ко всем валютам по коду
##############################################################################
@GET_all_by_code[]
	$result[$self._all_currencies_by_code]
#end @GET_all_by_code[]



##############################################################################
#	Свойство возвращает базовую валюту
##############################################################################
@GET_base[]
	$result[$self._base_currency]
#end @GET_base[]



##############################################################################
@after_update[]
	^BASE:after_update[]

	^rem{ *** если изменился курс относительно базовой валюты *** }
	^if($self.rate != $self.rate_was){
		^rem{ *** обновляем все цены, посчитанные в базовой валюте *** }
#		$r(^Goods:update_all[
#			$._price[price_cur * $self.rate]
#		][
#			$.condition[price_cur_id = $self.id]
#		])
#
#		$r(^Goods:update_all[
#			$._cost[cost_cur * $self.rate]
#		][
#			$.condition[cost_cur_id = $self.id]
#		])
	}

	^rem{ *** если это новая базовая валюта *** }
	^if($self.is_base && $self.is_base != $self.is_base_was){
		$r(^Currency:update_all[
			$.is_base[0]
		][
			$.condition[currency_id != $self.id]
		])

		^rem{ *** TODO: пересчитать все цены в эту валюту *** }
	}
#end @after_update[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.code){
		$self.code[^Urlify:urlify[$self.name]]
	}
#end @before_create[]
