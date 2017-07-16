import { createSelector } from 'reselect';
import { createSelector as ormCreateSelector } from 'redux-orm';

import { orm } from '../../../shemas';

import { prepareObject as prepareOrderObject } from '../../../shemas/order';

import { SCOPE as rootScope } from '../reducer';
import { SCOPE as collectionsScope } from '../reducer/collections';
import { SCOPE as filterScope } from '../reducer/filter';
import { SCOPE as listScope } from '../reducer/list';
import { SCOPE as crudScope } from '../reducer/crud';
import { SCOPE as massActionScope } from '../reducer/massActions';

export const ormSelector = state => state.orm;

export const scope = (state, props) => {
    return {
        collections: rootScope + '_' + collectionsScope,
        filter: rootScope + '_' + props.moduleName + '_' + filterScope,
        list: rootScope + '_' + props.moduleName + '_' + listScope,
        massAction: rootScope + '_' + props.moduleName + '_' + massActionScope,
        crud: rootScope + '_' + props.moduleName + '_' + crudScope,
        add_product: {
            collections: 'goodsModule_collections_',
            list: 'goodsModule_list_',
            filter: 'goodsModule_filter_',
        },
    }
};

export const page = (state, props) => state.ordersModule.orderLists[props.moduleName].list.page;
export const hasMore = (state, props) => state.ordersModule.orderLists[props.moduleName].list.hasMore;
export const loading = (state, props) => state.ordersModule.orderLists[props.moduleName].list.loading;

export const orders = createSelector(
    [
        ormSelector,
        (state, props) => state.ordersModule.orderLists[props.moduleName].list.selectedOrders
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running orders selector ', 'color: #89a72d');

        return session.Order
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => prepareOrderObject(session, sessionBoundModel));
    })
);

export const orderById = createSelector(
    [
        ormSelector,
        (state, props) => props.params.id
    ],
    ormCreateSelector(orm, (session, id) => {
        console.log('%c Running orderById#' + id + ' selector ', 'color: #89a72d');

        if (!session.Order.hasId(id)) {
            return undefined;
        }

        return prepareOrderObject(session, session.Order.withId(id));
    })
);

export const ausers = createSelector(
    [
        ormSelector,
        (state, props) => state.ordersModule.collections.ausers
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running ausers selector ', 'color: #89a72d');

        return session.User
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const orderStatuses = createSelector(
    [
        ormSelector,
        (state, props) => state.ordersModule.collections.orderStatuses
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running orderStatuses selector ', 'color: #89a72d');

        return session.OrderStatus
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const payments = createSelector(
    [
        ormSelector,
        (state, props) => state.ordersModule.collections.paymentTypes
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running payments selector ', 'color: #89a72d');

        return session.PaymentType
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const paymentStatuses = createSelector(
    [
        ormSelector,
        (state, props) => state.ordersModule.collections.paymentStatuses
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running paymentStatuses selector ', 'color: #89a72d');

        return session.PaymentStatus
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const deliveries = createSelector(
    [
        ormSelector,
        (state, props) => state.ordersModule.collections.deliveryTypes
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running deliveries selector ', 'color: #89a72d');

        return session.DeliveryType
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const currencies = createSelector(
    [
        ormSelector,
        (state, props) => state.ordersModule.collections.currencies
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running currencies selector ', 'color: #89a72d');

        return session.Currency
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const baseCurrency = createSelector(
    [ currencies ],
    currencies => currencies.filter(entity => entity.is_base)[0]
);

export const filter = createSelector(
    [
        ausers,
        orderStatuses,
        (state, props) => state.ordersModule.orderLists[props.moduleName].filter.filter
    ],
    (ausers, orderStatuses, filters) => {
        filters.forEach(filter => {
            let fieldName = filter.get('name'), widgetOption = filter.get('widgetOptions');

            if (fieldName == 'auser_id') {
                widgetOption.options = ausers.map(entity => {
                    return {
                        key: entity.id,
                        value: entity.title
                    }
                });
            }

            if (fieldName == 'status_id') {
                widgetOption.options = orderStatuses.map(entity => {
                    return {
                        key: entity.id,
                        value: entity.name
                    }
                });
            }
        });

        return filters;
    }
);

export const extendedCart = (state, props) => state.ordersModule.orderEdit.cart;

export const selectedOrders = (state, props) => state.ordersModule.orderLists[props.moduleName].massActions.ids;
export const selectedAction = (state, props) => state.ordersModule.orderLists[props.moduleName].massActions.currentAction;
export const massActions = (state, props) => state.ordersModule.orderLists[props.moduleName].massActions.actions;
