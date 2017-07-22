import { combineReducers } from 'redux';
import { createReducer } from 'redux-orm';
import { reducer as formReducer } from 'redux-form';
import { orm } from './shemas';
import app from './modules/App/reducer';
import auth from './modules/Login/reducer';

const rootReducer = combineReducers({
    app,
    auth,
    orm: createReducer(orm),
    form: formReducer
});

export default rootReducer;