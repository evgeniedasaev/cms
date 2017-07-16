import { ORDER_COLLECTIONS } from '../action';

export const SCOPE = 'collections_';

const INITIAL_STATE = {
    colleсtionsLoaded: false,
    ausers: [],
    paymentTypes: [],
    paymentStatuses: [],
    deliveryTypes: [],
    currencies: [],
    orderStatuses: []
};

export default function listReducerFactory(rootScope = "") {
    const scope = rootScope + SCOPE;

    return (state = INITIAL_STATE, action) => {
        const { type } = action;

        switch (type) {
            case scope + ORDER_COLLECTIONS.request:
                return fetchCollections(state, action);

            case scope + ORDER_COLLECTIONS.success:
                return fetchCollectionsSuccess(state, action);

            case scope + ORDER_COLLECTIONS.failure:
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
                case 'currency':
                    stateNew.currencies.push(entity.id);
                    
                    break;
                case 'user':
                    stateNew.ausers.push(entity.id);

                    break;
                case 'order_status':
                    stateNew.orderStatuses.push(entity.id);

                    break;
                case 'payment_type':
                    stateNew.paymentTypes.push(entity.id);

                    break;
                case 'payment_status':
                    stateNew.paymentStatuses.push(entity.id);

                    break;
                case 'delivery_type':
                    stateNew.deliveryTypes.push(entity.id);

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