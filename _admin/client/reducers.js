import { combineReducers } from 'redux';
import { createReducer } from 'redux-orm';
import { reducer as formReducer } from 'redux-form';

import { orm } from './shemas';
import application from './modules/application/reducer';
import ordersModule from './modules/order/reducer';

const rootReducer = combineReducers({
    application,
    orm: createReducer(orm),
    form: formReducer,
    ordersModule
});

export default rootReducer;