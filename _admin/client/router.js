import React from 'react';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';

import store from './store';
import App from './modules/application/containers/App';
import Login from './modules/application/containers/Login';

import orderRoutes from './modules/order/router';

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
}

export default (
    <Router history={browserHistory}>
        <Route path="/_admin/login" component={Login} />
        <Route path="/_admin" component={App} onEnter={checkAuth}>
            {orderRoutes}
        </Route>
    </Router>
);