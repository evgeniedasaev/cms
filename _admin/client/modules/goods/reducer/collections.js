import { GOODS_COLLECTIONS } from '../action';

export const SCOPE = 'add_product_';

const INITIAL_STATE = {
    colleсtionsLoaded: false,
    categories: [],
    brands: [],
    goodsTypes: []
};

export default function listReducerFactory(rootScope = "") {
    const scope = rootScope + SCOPE;

    return (state = INITIAL_STATE, action) => {
        const { type } = action;

        switch (type) {
            case scope + GOODS_COLLECTIONS.request:
                return fetchCollections(state, action);

            case scope + GOODS_COLLECTIONS.success:
                return fetchCollectionsSuccess(state, action);

            case scope + GOODS_COLLECTIONS.failure:
                return fetchCollectionsFailure(state, action);

            default:
                return state;
        }
    }
}

function fetchCollections(state, action) {
    return state;
}

function fetchCollectionsSuccess(state, action) {
    const stateNew = { ...state };
    const { payload: { operations } } = action;

    Object.values(operations).map(opertation => {
        opertation.data.map(entity => {
            switch (entity.type) {
                case 'category':
                    stateNew.categories.push(entity.id);

                    break;
                case 'brand':
                    stateNew.brands.push(entity.id);

                    break;
                case 'goods_type':
                    stateNew.goodsTypes.push(entity.id);

                    break;
            }
        });
    });

    stateNew.colleсtionsLoaded = true;

    return stateNew;
}

function fetchCollectionsFailure(state, action) {
    return state;
}