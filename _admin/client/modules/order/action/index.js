import { API_METHODS, callAction } from '../../../middleware/api';

export const ORDER_COLLECTIONS = {
    request: "FETCH_ORDER_COLLECTIONS_REQUEST",
    success: "FETCH_ORDER_COLLECTIONS_SUCCESS",
    failure: "FETCH_ORDER_COLLECTIONS_FAILED"
};

export function fetchCollections(scope){
    return dispatch => {
        dispatch(callAction(
            [
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'currency',
                    params: {
                        sort: ['code']
                    }
                },
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'auser',
                    params: {
                        field: {
                            user: ['id', 'title']
                        },
                        sort: ['title']
                    }
                },
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'payment_type',
                    params: {
                        field: {
                            order_status: ['id', 'name', 'commision', 'code']
                        },
                        sort: ['sort_order']
                    }
                },
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'delivery_type'
                },
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'order_status',
                    params: {
                        field: {
                            order_status: ['id', 'name', 'color']
                        },
                        sort: ['sort_order']
                    }
                },
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'payment_status'
                }
            ],
            scope,
            ORDER_COLLECTIONS
        ));
    }
}

export const ORDER_LIST = {
    request: "FETCH_ORDER_LIST_REQUEST",
    success: "FETCH_ORDER_LIST_SUCCESS",
    failure: "FETCH_ORDER_LIST_FAILED"
};

export function fetchOrders(scope, filter, page) {
    const filterMap = {};

    filter.map(filterField => filterMap[filterField.get('name')] = filterField.get('value'));

    return dispatch => {
        dispatch(callAction(
            [
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'order',
                    params: {
                        include: ['cart','delivery','payment','status'],
                        filter: filterMap,
                        sort: ['-dt'],
                        page: {
                            number: page
                        }
                    }
                }
            ],
            scope,
            ORDER_LIST
        ));
    };
}

export const ORDER_FILTER = {
    changeValue: "ORDER_CHANGE_FILTER_VALUE"
};

export function changeFilterValue(scope, filterId, value) {
    return dispatch => {
        dispatch({
            type: scope + ORDER_FILTER.changeValue,
            payload: { filterId, value }
        })
    };
}

export const ORDER_ITEM_FETCH = {
    request: "FETCH_ORDER_ITEM_REQUEST",
    success: "FETCH_ORDER_ITEM_SUCCESS",
    failure: "FETCH_ORDER_ITEM_FAILED"
};

export function fetchOrder(scope, orderId) {
    return dispatch => {
        dispatch(callAction(
            [
                {
                    method: API_METHODS.fetchItem,
                    endpoint: 'order',
                    params: {
                        id: orderId,
                        include: ['cart','delivery','payment','status']
                    }
                }
            ],
            scope,
            ORDER_ITEM_FETCH
        ));
    };
}

export const ORDER_ITEM_UPDATE = {
    request: "UPDATE_ORDER_ITEM_REQUEST",
    success: "UPDATE_ORDER_ITEM_SUCCESS",
    failure: "UPDATE_ORDER_ITEM_FAILED"
};

export function updateOrder(scope, orderData) {
    const operations = [];

    orderData.cart.map(cartItem => {
        operations.push({
            method: API_METHODS.updateItem,
            endpoint: 'order_cart',
            params: {
                data: {
                    id: cartItem.id,
                    type: 'order_cart',
                    attributes: cartItem
                }
            }
        });
    });

    operations.push({
        method: API_METHODS.updateItem,
        endpoint: 'order',
        params: {
            data: {
                id: orderData.id,
                type: 'order',
                attributes: orderData
            }
        }
    });

    // operations.push({
    //     method: API_METHODS.fetchItem,
    //         endpoint: 'order',
    //             params: {
    //             id: orderId,
    //             include: ['cart', 'delivery', 'payment', 'status']
    //     }
    // });

    return dispatch => {
        dispatch(callAction(
            operations,
            scope,
            ORDER_ITEM_UPDATE
        ));
    };
}

export const ORDER_CART = {
    update: "ORDER_CART_UPDATE"
};

export function updateOrderCart(scope, order) {
    return dispatch => {
        dispatch({
            type: scope + ORDER_CART.update,
            payload: order
        })
    };
}

export const ORDER_PRODUCT_ADD = {
    request: "ADD_ORDER_PRODUCT_REQUEST",
    success: "ADD_ORDER_PRODUCT_SUCCESS",
    failure: "ADD_ORDER_PRODUCT_FAILED"
};

export function updateOrderProduct(scope, orderId, productId, amount = 1) {
    return dispatch => {
        dispatch(callAction(
            [
                {
                    method: API_METHODS.createItem,
                    endpoint: 'order_cart',
                    params: {
                        data: {
                            type: 'order_cart',
                            attributes: {
                                order_id: orderId,
                                goods_id: productId,
                                amount: amount
                            }
                        }
                    }
                },
                {
                    method: API_METHODS.fetchItem,
                    endpoint: 'order',
                    params: {
                        id: orderId,
                        include: ['cart', 'delivery', 'payment', 'status']
                    }
                }
            ],
            scope,
            ORDER_PRODUCT_ADD
        ));
    };
}

export const ORDER_MASS_ACTION = {
    selectOrder: "ORDER_MASS_ACTION_SELECT_ORDER",
    selectAction: "ORDER_MASS_ACTION_SELECT_ACTION",
    clear: "ORDER_MASS_ACTION_CLEAR"
};

export function selectOrder(scope, id) {
    return dispatch => {
        dispatch({
            type: scope + ORDER_MASS_ACTION.selectOrder,
            payload: { id }
        })
    };
}

export function selectAction(scope, action) {
    return dispatch => {
        dispatch({
            type: scope + ORDER_MASS_ACTION.selectAction,
            payload: { action }
        })
    };
}

export function clear(scope) {
    return dispatch => {
        dispatch({
            type: scope + ORDER_MASS_ACTION.clear
        })
    };
}

export function assignManager(scope, orderIds, managerId) {
    const operations = [];

    orderIds.map(orderId => operations.push({
        method: API_METHODS.updateItem,
        endpoint: 'order',
        params: {
            data: {
                id: orderId,
                type: 'order',
                attributes: {
                    auser_id: managerId
                }
            }
        }
    }));

    return dispatch => {
        dispatch(callAction(
            operations,
            scope,
            ORDER_ITEM_UPDATE
        ));
    };
}

export function changeStatusManager(scope, orderIds, orderStatusId) {
    const operations = [];

    orderIds.map(orderId => operations.push({
        method: API_METHODS.updateItem,
        endpoint: 'order',
        params: {
            data: {
                id: orderId,
                type: 'order',
                attributes: {
                    status_id: orderStatusId
                }
            }
        }
    }));

    return dispatch => {
        dispatch(callAction(
            operations,
            scope,
            ORDER_ITEM_UPDATE
        ));
    };
}
