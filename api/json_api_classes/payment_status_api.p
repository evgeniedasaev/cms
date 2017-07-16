##############################################################################
#
##############################################################################

@CLASS
PaymentStatusApi

@USE
json_api/json_api.p

@OPTIONS
locals

@BASE
JsonApi



##############################################################################
@create[hParams;sVersion]
    $self._api_params[^prepare_params[$hParams]]
    $self._api_params_raw[^hash::create[$hParams]]

    $self._version[$sVersion]
#end @create[]



##############################################################################
@fetch_list[]
    $data[^array::create[]]

    ^Order:ORDER_PAYMENT_STATUSES.foreach[id;attributes]{
        ^data.add[
            $.type[payment_status]
            $.id[$id]
            $.attributes[$attributes]
        ]
    }
    
    $result[
        $.data[$data]
        $.jsonapi[
            $.version[$self._version]
        ]
    ]
#end @fetch_list[]