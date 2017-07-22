import {Route} from 'react-router-dom';

import LoginIndex from './containers/Index';

export default [
    {
        path: '/login',
        name: 'Вход',
        tag: Route,
        component: LoginIndex
    }
]