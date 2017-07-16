import React, { PureComponent, PropTypes } from 'react';
import { Link } from 'react-router';
import RawHtml from "react-raw-html";
import dateFormat from 'dateformat';

export default class OrderPreview extends PureComponent {

    render() {
        const { order, selected, baseCurrency, onChange } = this.props;

        const carts = [];
        if ("cart" in order) {
            Object.values(order.cart).forEach(function(cartItem, index) {
                carts.push(<div key={index}>{cartItem.name + '\u00A0\u00D7\u00A0' + cartItem.amount}</div>);
            })
        }

        return (
            <div className="row-fluid" key={order.id}>
                <div className="span1">
                    <input
                        type="checkbox"
                        checked={selected}
                        onChange={onChange}
                    />
                    &nbsp;
                    <Link to={order.order_link}>{order.code}</Link>
                </div>
                <div className="span2">{dateFormat(new Date(order.dt), "dd.mm.yyyy hh:MM")}</div>
                <div className="span2">
                    <a href={order.customer_link}>{order.user_name}</a>
                    {order.phone ? <div>{order.phone}</div> : ''}
                    {order.email ? <div>{order.email}</div> : ''}
                    {order.address ? <div>{order.address}</div> : ''}
                    {order.delivery ? <div>{order.delivery.name}</div> : ''}
                    {order.payment ? <div>{order.payment.name}</div> : ''}
                    {order.auserComment ? <div>{order.auser_comment}</div> : ''}
                </div>
                <div className="span2">{ carts }</div>
                <div className="span2">
                    {
                        typeof baseCurrency !== 'undefined' &&
                        (
                            parseFloat(order.total).toLocaleString('ru-RU', { style: 'currency', currency: baseCurrency.code }) ||
                            parseFloat(order.total)
                        )
                    }
                </div>
                <div className="span1">
                    <div>{order.dt_delivery && dateFormat(new Date(order.dt_delivery), "dd.mm.yyyy")}</div>
                    <div>{order.dt_delivery_time_string}</div>
                </div>
                <div className="span2">
                    <div className="row-fluid">
                        <div className="span6 offset4">
                            <span style={{
                                color: order.orderStatus.color
                            }}>{order.orderStatus.name}</span>
                        </div>
                        <div className="span2">
                            {
                                order.is_success ?
                                    <i className="fa fa-toggle-on fa-lg" aria-hidden="true" style={ { color: "green" } } />
                                :
                                    <i className="fa fa-toggle-off fa-lg" aria-hidden="true" />
                            }
                            <RawHtml.span>{order.finished}</RawHtml.span>
                        </div>
                    </div>
                </div>
            </div>
        );
    };
};
