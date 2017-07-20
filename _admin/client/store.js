import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import 'babel-polyfill';

import API from './api';
import rootReducer from './reducers';

const INITIAL_STATE = {};

const store = createStore(
    rootReducer,
    INITIAL_STATE,
    window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__(),
    applyMiddleware(
        thunk,
        API('http://cms:8080/api/')
    )
);

export default store;