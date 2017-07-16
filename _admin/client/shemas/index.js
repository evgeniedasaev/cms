import { ORM } from 'redux-orm';

import Order from './order';
import OrderCart from './orderCart';
import User from './user';
import OrderStatus from './orderStatus';
import GeoCity from './geoCity';
import Currency from './currency';
import DeliveryType from './deliveryType';
import DiscountType from './discountType';
import PaymentType from './paymentType';
import PaymentStatus from './paymentStatus';
import Bill from './bill';
import Goods from './goods';
import Category from './category';
import Brand from './brand';
import GoodsType from './goodsType';

export const orm = new ORM();
orm.register(
    Order,
    OrderCart,
    User,
    OrderStatus,
    GeoCity,
    Currency,
    DeliveryType,
    DiscountType,
    PaymentType,
    PaymentStatus,
    Bill,
    Goods,
    Category,
    Brand,
    GoodsType
);

export default orm;