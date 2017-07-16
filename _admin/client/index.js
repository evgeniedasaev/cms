import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { Router, browserHistory } from 'react-router';

import store from './store';
import router from './router';

import './semantic/dist/semantic.min.css';

const rootElement = document.getElementById('app');

render(
    <Provider store={store}>
        <Router history={browserHistory} routes={router} />
    </Provider>,
    rootElement
);