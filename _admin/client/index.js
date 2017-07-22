import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import {ConnectedRouter as Router} from 'react-router-redux'
import store from './store';
import {Routing as routes, history} from './routing';
import './style';
import {ThemeProvider} from 'styled-components';
import theme from './theme';

const rootElement = document.getElementById('app');

/**
 * Checks Auth logic. Is user allowed to visit certain path?
 * @param  {String} path next path to visit
 * @return {Bool} is user allowed to visit next location?
 * check RouteAuth component.
 */
const authCheck = path => {
    const {store} = this.props
    const {isLoggedIn} = store.getState().app
    const authPath = '/login'
    const allowedToVisitPath = [authPath]

    if (isLoggedIn && path === authPath) {
        return false
    } else if (!isLoggedIn && !allowedToVisitPath.includes(path)) {
        return false
    }
    return true
}

render(
    <Provider store={store} key={Math.random()}>
        <Router history={history} key={Math.random()}>
            <ThemeProvider theme={theme}>
                {routes(authCheck)}
            </ThemeProvider>
        </Router>
    </Provider>,
    rootElement
);