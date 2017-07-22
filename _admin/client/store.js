import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import 'babel-polyfill';
import API from './api';
import rootReducer from './reducers';

const INITIAL_STATE = {};

const composeEnhancers =
  typeof window === 'object' &&
  window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ ?   
    window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__({
      // Specify extension’s options like name, actionsBlacklist, actionsCreators, serialize...
    }) : compose;

const store = createStore(
    rootReducer,
    INITIAL_STATE,
    composeEnhancers(
        applyMiddleware(
            thunk,
            API('http://cms:8080/api/')
        )
    )
);

export default store;