import React from 'react'
import {Route, Redirect, Switch} from 'react-router-dom'
import {createBrowserHistory} from 'history'
import AppIndex from './modules/App/containers/Index';

import AppRouter from './modules/App/router';
import LoginRouter from './modules/Login/router';

export const appRouting = [
  ...LoginRouter,
  ...AppRouter,
];

export const history = createBrowserHistory({
    basename: '/_admin'
})

const loadLazyComponent = url => {
  return async cb => {
    const loadComponent = await import(/* webpackMode: "lazy-once", webpackChunkName: "lazy-containers" */ url)
    return loadComponent
  }
}

/**
 * Checks Auth logic. Is user allowed to visit certain path?
 * @param  {String} path next path to visit
 * @return {Bool} is user allowed to visit next location?
 * check RouteAuth component.
 */
const authCheck = (store, path) => {
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

/**
 * Returns application routing with protected by AuthCheck func routes
 */
export const Routing = store => {
  // remove components that aren't application routes, (e.g. github link in sidebar)
  const routes = appRouting.filter(
    a => a.tag || a.component || a.lazy || !a.external
  )
  // render components that are inside Switch (main view)
  const routesRendered = routes.map((a, i) => {
    // get tag for Route.
    // is it "RouteAuth" `protected route` or "Route"?
    const Tag = a.tag
    const {path, exact, strict, component, lazy} = a
    // can visitor access this route?
    const canAccess = authCheck.bind(this, store)
    // define component
    const loadedComponent = !lazy ? component : loadLazyComponent(component);
    // select only props that we need
    const b = {path, exact, strict, component: loadedComponent, canAccess, lazy}

    return <Tag key={i} {...b} />
  })

  return (
    <AppIndex>
        <Switch>
            {routesRendered}
            <Redirect to="/" />
        </Switch>
    </AppIndex>
  )
}
