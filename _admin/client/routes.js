import React from 'react';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';

import store from './store';

import AppIndex from './modules/App/containers/Index';

export default (
    <Route path="/_admin" component={AppIndex} />
);

/* import App from './modules/Login/containers/App';
import Login from './modules/Login/containers/Login';

import orderRoutes from './modules/Order/router';

function checkAuth(nextState, replaceState) {
    const { application: { loggedIn } } = store.getState();

    if (nextState.location.pathname != '/_admin/login') {
        if (!loggedIn) {
            replaceState({
                pathname: '/_admin/login',
                state: { nextPathname: nextState.location.pathname }
            });
        }
    } else {
        if (loggedIn) {
            replaceState({
                pathname: '/_admin/order/'
            });
        }
    }
} */
