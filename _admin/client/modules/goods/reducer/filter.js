import { GOODS_FILTER } from '../action';

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
            name: 'code',
            displayName: 'Код',
            widget: StringWidget,
            operator: operators.CONTAINS,
            value: getValue(StringWidget.defaultValue, operators.CONTAINS)
        }),
        1: Map({
            name: 'text',
            displayName: 'ID или Название',
            widget: StringWidget,
            operator: operators.CONTAINS,
            value: getValue(StringWidget.defaultValue, operators.CONTAINS)
        }),
        2: Map({
            name: 'category_id',
            displayName: 'Категория',
            widget: SelectWidget,
            widgetOptions: { options: [] },
            operator: operators.EQUALS,
            value: getValue(SelectWidget.defaultValue, operators.BETWEEN)
        }),
        3: Map({
            name: 'type_id',
            displayName: 'Тип товара',
            widget: SelectWidget,
            widgetOptions: { options: [] },
            operator: operators.EQUALS,
            value: getValue(SelectWidget.defaultValue, operators.EQUALS)
        }),
        4: Map({
            name: 'brand_id',
            displayName: 'Бренд',
            widget: SelectWidget,
            widgetOptions: { options: [] },
            operator: operators.EQUALS,
            value: getValue(SelectWidget.defaultValue, operators.EQUALS)
        }),
        5: Map({
            name: 'published',
            displayName: 'Опубликованность',
            widget: SelectWidget,
            widgetOptions: { options: [
                {
                    key: -1,
                    value: 'Все'
                },
                {
                    key: 1,
                    value: 'Опубликованные'
                },
                {
                    key: 0,
                    value: 'Скрытые'
                }
            ] },
            operator: operators.EQUALS,
            value: getValue(SelectWidget.defaultValue, operators.EQUALS)
        }),
        // 6: Map({
        //     name: 'availible',
        //     displayName: 'Доступность',
        //     widget: SelectWidget,
        //     widgetOptions: {
        //         options: [
        //             {
        //                 key: -1,
        //                 value: 'Все'
        //             },
        //             {
        //                 key: 2,
        //                 value: 'Дефицит'
        //             },
        //             {
        //                 key: 1,
        //                 value: 'В наличии'
        //             },
        //             {
        //                 key: 0,
        //                 value: 'Нет в наличии'
        //             }
        //         ]
        //     },
        //     operator: operators.EQUALS,
        //     value: getValue(SelectWidget.defaultValue, operators.EQUALS)
        // }),
        // 7: Map({
        //     name: 'is_complect',
        //     displayName: 'Является комлектом',
        //     widget: SelectWidget,
        //     widgetOptions: {
        //         options: [
        //             {
        //                 key: -1,
        //                 value: 'Все'
        //             },
        //             {
        //                 key: 1,
        //                 value: 'Комплекты'
        //             },
        //             {
        //                 key: 0,
        //                 value: 'Не комплекты'
        //             }
        //         ]
        //     },
        //     operator: operators.EQUALS,
        //     value: getValue(SelectWidget.defaultValue, operators.EQUALS)
        // })
    })
};

export const SCOPE = 'filter_';

export default function filterReducerFactory(rootScope = "") {
    const scope = rootScope + SCOPE;

    return (state = INITIAL_STATE, action) => {
        const { type } = action;

        switch (type) {
            case scope + GOODS_FILTER.changeValue:
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