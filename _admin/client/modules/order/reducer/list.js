import { ORDER_LIST } from '../action';

const INITIAL_STATE = {
    selectedOrders: [],
    page: 0,
    hasMore: true,
    error: null,
    loading: false
}

export const SCOPE = 'list_';

export default function listReducerFactory(rootScope = "") {
    const scope = rootScope + SCOPE;

    return (state = INITIAL_STATE, action) => {
        const { type } = action;

        switch (type) {
            case scope + ORDER_LIST.request:
                return fetchOrders(state, action);

            case scope + ORDER_LIST.success:
                return fetchOrdersSuccess(state, action);

            case scope + ORDER_LIST.failure:
                return fetchOrdersFailure(state, action);

            default:
                return state;
        }
    }
}

function fetchOrders(state, action) {
    return {
        ...state,
        error: null,
        loading: true,
        hasMore: false
    };
}

function fetchOrdersSuccess(state, action) {
    const { payload: { operations } } = action;
    const { data, meta } = Object.values(operations)[0];
    const ids = (typeof data !== 'undefined') ? data.map(entity => entity.id) : [];

    let { selectedOrders, page, hasMore } = state;

    page = ('page_num' in meta) ? parseInt(meta.page_num) : page;
    hasMore = ('page_amount' in meta) ? (page <= parseInt(meta.page_amount)) : hasMore;

    if (page == 1) {
        selectedOrders = ids;
    } else if (state.page < page) {
        selectedOrders = selectedOrders + ids;
    }

    return {
        ...state,
        error: null,
        loading: false,
        page,
        hasMore,
        selectedOrders
    };
}

function fetchOrdersFailure(state, action) {
    return {
        ...state,
        error: null,
        loading: false,
        hasMore: false
    };
}
