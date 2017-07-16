import { createSelector } from 'reselect';
import { createSelector as ormCreateSelector } from 'redux-orm';

import { orm } from '../../../shemas';

export const ormSelector = state => state.orm;

export const addProductPage = (state, props) => state.ordersModule.orderAddProduct.list.page;
export const addProductHasMore = (state, props) => state.ordersModule.orderAddProduct.list.hasMore;
export const addProductLoading = (state, props) => state.ordersModule.orderAddProduct.list.loading;

export const goods = createSelector(
    [
        ormSelector,
        (state, props) => state.ordersModule.orderAddProduct.list.selectedGoods
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
        (state, props) => state.ordersModule.orderAddProduct.collections.categories
    ],
    ormCreateSelector(orm, (session, ids) => {
        console.log('%c Running goods selector ', 'color: #89a72d');

        return session.Category
            .filter(entity => ids.indexOf(entity.id) >= 0)
            .toModelArray()
            .map(sessionBoundModel => Object.assign({}, sessionBoundModel.ref, { key: sessionBoundModel.id }));
    })
);

export const brands = createSelector(
    [
        ormSelector,
        (state, props) => state.ordersModule.orderAddProduct.collections.brands
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
        (state, props) => state.ordersModule.orderAddProduct.collections.goodsTypes
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
        (state, props) => state.ordersModule.orderAddProduct.filter.filter
    ],
    (categories, brands, goodsTypes, filters) => {
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

            if (fieldName == 'type_id') {
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