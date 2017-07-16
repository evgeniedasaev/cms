import { API_METHODS, callAction } from '../../../middleware/api';

export const GOODS_COLLECTIONS = {
    request: "FETCH_GOODS_COLLECTIONS_REQUEST",
    success: "FETCH_GOODS_COLLECTIONS_SUCCESS",
    failure: "FETCH_GOODS_COLLECTIONS_FAILED"
};

export function fetchCollections(scope) {
    return dispatch => {
        dispatch(callAction(
            [
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'category',
                    params: {
                        field: {
                            object: ['id', 'name', 'parent_id', 'nested']
                        }
                    }
                },
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'brand',
                    params: {
                        field: {
                            brand: ['id', 'name']
                        }
                    }
                },
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'goods_type',
                    params: {
                        field: {
                            goods_type: ['id', 'name']
                        }
                    }
                }
            ],
            scope,
            GOODS_COLLECTIONS
        ));
    }
}

export const GOODS_LIST = {
    request: "FETCH_GOODS_LIST_REQUEST",
    success: "FETCH_GOODS_LIST_SUCCESS",
    failure: "FETCH_GOODS_LIST_FAILED"
};

export function fetchGoods(scope, filter, page) {
    const filterMap = {};

    filter.map(filterField => filterMap[filterField.get('name')] = filterField.get('value'));

    return dispatch => {
        dispatch(callAction(
            [
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'goods',
                    params: {
                        filter: filterMap,
                        page: {
                            number: page
                        }
                    }
                }
            ],
            scope,
            GOODS_LIST
        ));
    };
}

export const GOODS_FILTER = {
    changeValue: "GOODS_CHANGE_FILTER_VALUE"
};

export function changeFilterValue(scope, filterId, value) {
    return dispatch => {
        dispatch({
            type: scope + GOODS_FILTER.changeValue,
            payload: { filterId, value }
        })
    };
}