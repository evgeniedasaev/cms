import { combineReducers } from 'redux';
import { reducer as formReducer } from 'redux-form';

import collectionsReducerFactory from './collections';
import listReducerFactory from './list';
import filterReducerFactory from './filter';
import crudReducerFactory from './crud';
import massActionReducerFactory from './massActions';

import goodsCollectionsReducerFactory from '../../goods/reducer/collections';
import goodsFilterReducerFactory from '../../goods/reducer/filter';
import goodsListReducerFactory from '../../goods/reducer/list';

export const SCOPE = 'ordersModule';

export default combineReducers({
    collections: collectionsReducerFactory(SCOPE + '_'),
    orderLists: combineReducers({
        single: combineReducers({
            list: listReducerFactory(SCOPE + '_single_'),
            filter: filterReducerFactory(SCOPE + '_single_'),
            massActions: massActionReducerFactory(SCOPE + '_single_')
        })
    }),
    orderEdit: crudReducerFactory(SCOPE + '_edit_'),
    orderAddProduct: combineReducers({
        collections: goodsCollectionsReducerFactory('goodsModule_'),
        filter: goodsFilterReducerFactory('goodsModule_'),
        list: goodsListReducerFactory('goodsModule_')
    })
});