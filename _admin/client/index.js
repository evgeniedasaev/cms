import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { Router, browserHistory } from 'react-router';

import store from './store';
import routes from './routes';

import './style';

import {ThemeProvider} from 'styled-components';
import theme from './theme';

const rootElement = document.getElementById('app');

render(
    <Provider store={store}>
        <ThemeProvider theme={theme}>
            <Router history={browserHistory} routes={routes} />
        </ThemeProvider>
    </Provider>,
    rootElement
);