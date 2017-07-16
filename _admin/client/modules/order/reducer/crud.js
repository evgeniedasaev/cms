import { ORDER_ITEM_FETCH, ORDER_ITEM_UPDATE, ORDER_CART, ORDER_PRODUCT_ADD } from '../action';

export const SCOPE = 'crud_';

const INITIAL_STATE = {
    orderId: null,
    error: null,
    loading: false,
    cart: {
        items: {},
        total: 0,
        margin: 0,
        discount: 0,
        saving: 0
    }
}

export default function crudReducerFactory(rootScope = "") {
    const scope = rootScope + SCOPE;

    return (state = INITIAL_STATE, action) => {
        const { type } = action;

        switch (type) {
            case scope + ORDER_ITEM_FETCH.request:
                return fetchOrder(state, action);

            case scope + ORDER_ITEM_FETCH.success:
                return fetchOrderSuccess(state, action);

            case scope + ORDER_ITEM_UPDATE.request:
                return updateOrder(state, action);

            case scope + ORDER_ITEM_UPDATE.success:
                return updateOrderSuccess(state, action);

            case scope + ORDER_CART.update:
                return updateOrderCart(state, action);

            case scope + ORDER_PRODUCT_ADD.request:
                return updateOrder(state, action);

            case scope + ORDER_PRODUCT_ADD.success:
                return addOrderCart(state, action);

            default:
                return state;
        }
    }
}

function fetchOrder(state, action) {
    return {
        ...state,
        error: null,
        loading: true
    };
}

function fetchOrderSuccess(state, action) {
    return {
        ...state,
        error: null,
        loading: false
    };
}

function updateOrder(state, action) {
    return {
        ...state,
        error: null,
        loading: true
    };
}

function updateOrderSuccess(state, action) {
    return {
        ...state,
        error: null,
        loading: false
    };
}

function addOrderCart(state, action) {
    return state;
    // return _updateOrder(state, order);
}

function updateOrderCart(state, action) {
    const { payload: order } = action;

    return _updateOrder(state, order);
}

function _updateOrder(state, order) {
    let items = {}, total = 0, totalWithoutDiscount = 0, margin = 0, discount = 0, saving = 0;

    order.cart.map(item => {
        const cartItem = { ...item };

        cartItem.price = priceWithCurrencyRate(item.price_cur, item.price_cur_id);
        cartItem.priceWithDiscount = cartItem.price;
        if (item.price_discount) {
            cartItem.priceWithDiscount = priceWithDiscount(cartItem.price, item.price_discount, item.price_discount_type_id);
        }

        cartItem.total = cartItem.priceWithDiscount * item.amount;

        const costPrice = priceWithCurrencyRate(item.cost_cur, item.cost_cur_id);
        cartItem.margin = (costPrice) ? (cartItem.priceWithDiscount - costPrice) * item.amount : 0;

        items[item.id] = cartItem;

        totalWithoutDiscount += cartItem.price * item.amount;
        total += cartItem.total;
        margin += cartItem.margin;
    });

    const deliveryPrice = priceWithCurrencyRate(order.delivery_price_cur, order.delivery_price_cur_id);
    if (deliveryPrice) {
        totalWithoutDiscount += deliveryPrice;
        total += deliveryPrice;
    }

    if (order.payment && order.payment.commission) {
        totalWithoutDiscount *= (1 + order.payment.commission / 100);
        total *= (1 + order.payment.commission / 100);
    }

    saving = totalWithoutDiscount - total;
    discount = Math.round(saving * 100 / ((totalWithoutDiscount) ? totalWithoutDiscount : 1));

    return {
        ...state,
        cart: {
            items,
            total,
            margin,
            discount,
            saving
        }
    };
}

function priceWithCurrencyRate(price, priceCur) {
    return Math.round(parseFloat(price));
}

function priceWithDiscount(price, discount, discountType) {
    switch (discountType) {
        case '0':
            price *= 1 - discount / 100;
            break;

        default:
            price -= parseFloat(discount);
            break;
    }

    return Math.round(price);
} 
