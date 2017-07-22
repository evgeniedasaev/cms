import { combineReducers } from 'redux';
import { createReducer } from 'redux-orm';
import { reducer as formReducer } from 'redux-form';
import app from './modules/App/reducer';
import { orm } from './shemas';
import login from './modules/Login/reducer';
import orders from './modules/Order/reducer';

const rootReducer = combineReducers({
    app,
    orm: createReducer(orm),
    form: formReducer,
    /* login,
    orders */
});

export default rootReducer;