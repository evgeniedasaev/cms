import { ORDER_FILTER } from '../action';

import { Map, OrderedMap, Set, is } from 'immutable';

import * as operators from '../../../components/filterWidget/operators';
import { operatorsFilters } from '../../../components/filterWidget/operatorsFilters';

import StringWidget from '../../../components/filterWidget/StringWidget';
import NumberWidget from '../../../components/filterWidget/NumberWidget';
import DateWidget from '../../../components/filterWidget/DateWidget';
import BooleanWidget from '../../../components/filterWidget/BooleanWidget';
import SelectWidget from '../../../components/filterWidget/SelectWidget';

const INITIAL_STATE = {
    filter: OrderedMap({
        0: Map({
            name: 'query',
            displayName: '№, ФИО, тел, email',
            widget: StringWidget,
            operator: operators.CONTAINS,
            value: getValue(StringWidget.defaultValue, operators.CONTAINS)
        }),
        1: Map({
            name: 'dt',
            displayName: 'Дата заказа',
            widget: DateWidget,
            operator: operators.BETWEEN,
            value: getValue(DateWidget.defaultValue, operators.BETWEEN)
        }),
        2: Map({
            name: 'dt_delivery',
            displayName: 'Дата доставки',
            widget: DateWidget,
            operator: operators.BETWEEN,
            value: getValue(DateWidget.defaultValue, operators.BETWEEN)
        }),
        3: Map({
            name: 'auser_id',
            displayName: 'Менеджер',
            widget: SelectWidget,
            widgetOptions: { options: [] },
            operator: operators.EQUALS,
            value: getValue(SelectWidget.defaultValue, operators.BETWEEN)
        }),
        4: Map({
            name: 'status_id',
            displayName: 'Статус',
            widget: SelectWidget,
            widgetOptions: { options: [] },
            operator: operators.EQUALS,
            value: getValue(SelectWidget.defaultValue, operators.EQUALS)
        }),
    })
};

export const SCOPE = 'filter_';

export default function filterReducerFactory(rootScope = ""){
    const scope = rootScope + SCOPE;

    return (state = INITIAL_STATE, action) => {
        const { type } = action;

        switch (type) {
            case scope + ORDER_FILTER.changeValue:
                return changeFilterValue(state, action);

            default:
                return state;
        }
    }
}

function changeFilterValue(state, action) {
    const { payload: { filterId, value } } = action;

    if (typeof filterId === 'undefined' || typeof value === 'undefined')
        return state;

    state.filter = state.filter.setIn([filterId, 'value'], value);

    return {
        ...state
    };
}

function getValue(value, operator) {
    const isArray = Array.isArray(value);
    if (operator == operators.BETWEEN || operator == operators.NOT_BETWEEN) {
        return isArray ? value : [value, ''];
    } else {
        return isArray ? value[0] : value;
    }
}