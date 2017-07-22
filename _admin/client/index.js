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

render(
    <Provider store={store} key={Math.random()}>
        <Router history={history} key={Math.random()}>
            <ThemeProvider theme={theme}>
                {routes(store)}
            </ThemeProvider>
        </Router>
    </Provider>,
    rootElement
);