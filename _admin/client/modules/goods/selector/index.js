import { createSelector } from 'reselect';
import { createSelector as ormCreateSelector } from 'redux-orm';

import { orm } from '../../../shemas';

import { prepareObject as prepareOrderObject } from '../../../shemas/order';

import { SCOPE as rootScope } from '../reducer';
import { SCOPE as collectionsScope } from '../reducer/collections';
import { SCOPE as filterScope } from '../reducer/filter';
import { SCOPE as listScope } from '../reducer/list';

export const ormSelector = state => state.orm;

export const scope = (state, props) => {
    return {
        collections: rootScope + '_' + collectionsScope,
        filter: rootScope + '_' + props.moduleName + '_' + filterScope,
        list: rootScope + '_' + props.moduleName + '_' + listScope
    }
};

export const page = (state, props) => state.goodsModule.orderLists[props.moduleName].list.page;
export const hasMore = (state, props) => state.goodsModule.orderLists[props.moduleName].list.hasMore;
export const loading = (state, props) => state.goodsModule.orderLists[props.moduleName].list.loading;

export const goods = createSelector(
    [
        ormSelector,
        (state, props) => state.goodsModule.collections.goods
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running goods selector ', 'color: #89a72d');

        return session.Goods
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const categories = createSelector(
    [
        ormSelector,
        (state, props) => state.goodsModule.collections.categories
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running goods selector ', 'color: #89a72d');

        return session.Goods
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const brands = createSelector(
    [
        ormSelector,
        (state, props) => state.goodsModule.collections.brands
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running brands selector ', 'color: #89a72d');

        return session.Brand
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const goodsTypes = createSelector(
    [
        ormSelector,
        (state, props) => state.goodsModule.collections.goodsTypes
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running goodsTypes selector ', 'color: #89a72d');

        return session.GoodsType
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const filter = createSelector(
    [
        categories,
        brands,
        goodsTypes,
        (state, props) => state.goodsModule.goodsLists[props.moduleName].filter.filter
    ],
    (ausers, orderStatuses, filters) => {
        filters.forEach(filter => {
            let fieldName = filter.get('name'), widgetOption = filter.get('widgetOptions');

            if (fieldName == 'category_id') {
                widgetOption.options = categories.map(entity => {
                    return {
                        key: entity.id,
                        value: entity.name
                    }
                });
            }

            if (fieldName == 'brand_id') {
                widgetOption.options = brands.map(entity => {
                    return {
                        key: entity.id,
                        value: entity.name
                    }
                });
            }

            if (fieldName == 'goods_type_id') {
                widgetOption.options = goodsTypes.map(entity => {
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
