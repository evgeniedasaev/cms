import React from 'react'
import {Route, Redirect, Switch} from 'react-router-dom'
import {createBrowserHistory} from 'history'

import AppIndex from './modules/App/containers/Index/index.jsx';

export const appRouting = [];

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
 * Returns application routing with protected by AuthCheck func routes
 * @param {Function} authCheck checks is user logged in
 */
export const Routing = authCheck => {
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
    const canAccess = authCheck
    // select only props that we need
    const b = {path, exact, strict, component, canAccess, lazy}

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
