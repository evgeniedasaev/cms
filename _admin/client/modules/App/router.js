import RouteAuth from '../Login/containers/Route';
import LoginIndex from '../Login/containers/Index';

export default [
    {
        path: '/',
        tag: RouteAuth,
        component: LoginIndex
    }
]