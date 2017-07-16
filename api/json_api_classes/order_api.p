##############################################################################
#
##############################################################################

@CLASS
OrderApi

@USE
json_api/json_api.p

@OPTIONS
locals

@BASE
JsonApi



##############################################################################
# Определяем resource
##############################################################################
@define_resource[]
	$result[^Order:confirmed[]]
#end @define_resource[]



##############################################################################
# Перекрываем фильтр для заказов
##############################################################################
@define_filter[]
	^if(def $self._api_params.filter.query){
		$self._resource[^self._resource.where[(
			order.code LIKE '%$self._api_params.filter.query%' OR
			order.first_name LIKE '%$self._api_params.filter.query%' OR
			order.email LIKE '%$self._api_params.filter.query%' OR
			order.phone LIKE '%$self._api_params.filter.query%' OR
			order.phone_2 LIKE '%$self._api_params.filter.query%'
		)]]
	}

	^if($self._api_params.filter.dt){
		^if(def $self._api_params.filter.dt.0){
			$dt_filter_from[^date::create[$self._api_params.filter.dt.0]]
			$self._resource[^self._resource.where[order.dt >= "^dt_filter_from.sql-string[]"]]
		}
		^if(def $self._api_params.filter.dt.1){
			$dt_filter_to[^date::create[$self._api_params.filter.dt.1]]
			$self._resource[^self._resource.where[order.dt < "^dt_filter_to.sql-string[]"]]
		}
	}

	^if($self._api_params.filter.dt_delivery){
		^if(def $self._api_params.filter.dt_delivery.0){
			$dt_filter_from[^date::create[$self._api_params.filter.dt_delivery.0]]
			$self._resource[^self._resource.where[order.dt_delivery >= "^dt_filter_from.sql-string[]"]]
		}
		^if(def $self._api_params.filter.dt_delivery.1){
			$dt_filter_to[^date::create[$self._api_params.filter.dt_delivery.1]]
			$self._resource[^self._resource.where[order.dt_delivery < "^dt_filter_to.sql-string[]"]]
		}
	}

	^if($self._api_params.filter.auser_id){
		$self._resource[^self._resource.where[order.auser_id IN (^foreach[$self._api_params.filter.auser_id;auser_id]{$auser_id}[,])]]
	}

	^if($self._api_params.filter.status_id){
		$self._resource[^self._resource.where[order.status_id IN (^foreach[$self._api_params.filter.status_id;status_id]{$status_id}[,])]]
	}
#end @define_filter[]
