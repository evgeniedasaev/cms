import { GOODS_LIST } from '../action';

const INITIAL_STATE = {
    selectedGoods: [],
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
            case scope + GOODS_LIST.request:
                return fetchGoods(state, action);

            case scope + GOODS_LIST.success:
                return fetchGoodsSuccess(state, action);

            case scope + GOODS_LIST.failure:
                return fetchGoodsFailure(state, action);

            default:
                return state;
        }
    }
}

function fetchGoods(state, action) {
    return {
        ...state,
        error: null,
        loading: true,
        hasMore: false
    };
}

function fetchGoodsSuccess(state, action) {
    const { payload: { operations } } = action;
    const { data, meta } = Object.values(operations)[0];
    const ids = (typeof data !== 'undefined') ? data.map(entity => entity.id) : [];

    let { selectedGoods, page, hasMore } = state;

    page = ('page_num' in meta) ? parseInt(meta.page_num) : page;
    hasMore = ('page_amount' in meta) ? (page <= parseInt(meta.page_amount)) : hasMore;

    if (page == 1) {
        selectedGoods = ids;
    } else if (state.page < page) {
        selectedGoods = selectedGoods + ids;
    }

    return {
        ...state,
        error: null,
        loading: false,
        page,
        hasMore,
        selectedGoods
    };
}

function fetchGoodsFailure(state, action) {
    return {
        ...state,
        error: null,
        loading: false,
        hasMore: false
    };
}
