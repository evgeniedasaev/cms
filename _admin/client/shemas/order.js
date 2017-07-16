import { Model, many, fk, attr } from 'redux-orm';
import schemaBase from './schemaBase';

export default class Order extends schemaBase {
    static get modelName() {
        return 'Order';
    }
}

export function prepareObject(session, sessionBoundModel) {
    const obj = {
        ...sessionBoundModel.ref,
        key: sessionBoundModel.id
    };

    obj.cart = session.OrderCart.filter(orderCart => obj.cart.indexOf(orderCart.id) >= 0).toModelArray().map(entity => {
        return {
            ...entity.ref,
            key: entity.id
        };
    });

    if (session.DeliveryType.hasId(obj.delivery_id)) {
        obj.delivery = session.DeliveryType.withId(obj.delivery_id).ref;
    }

    if (session.PaymentType.hasId(obj.payment_id)) {
        obj.payment = session.PaymentType.withId(obj.payment_id).ref;
    }

    if (session.PaymentStatus.hasId(obj.payment_status_id)) {
        obj.paymentStatus = session.PaymentStatus.withId(obj.payment_status_id).ref;
    }

    if (session.OrderStatus.hasId(obj.status_id)) {
        obj.orderStatus = session.OrderStatus.withId(obj.status_id).ref;
    }

    return obj;
}