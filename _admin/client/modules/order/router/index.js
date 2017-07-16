import React from 'react';
import { Route } from 'react-router';

import OrderRoot from '../containers/Root';
import OrderIndex from '../containers/Index';
import OrderEdit from '../containers/Edit';

import GoodsRoot from '../../goods/containers/Root';
import OrderAddProduct from '../containers/AddProduct';

const orderRoutes = (
    <Route key="orderRoot" component={OrderRoot}>
        <Route key="orderIndex" path="order/" component={OrderIndex} />
        <Route key="orderEdit" path="order/view/:id" component={OrderEdit} />
        <Route key="goodsRoot" component={GoodsRoot}>
            <Route key="orderAddProduct" path="order/add_cart_item/:id" component={OrderAddProduct} />
        </Route >
    </Route >
);

export default orderRoutes;