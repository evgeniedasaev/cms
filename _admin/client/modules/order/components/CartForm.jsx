import React, { PureComponent, PropTypes } from 'react';

import { Field } from 'redux-form';
import SelectField from '../../App/componentsformWidget/SelectField';

export default class OrderCartForm extends PureComponent {

    render() {
        const { order, orderCart: orderCartInfo } = this.props;

        const cartBlock = [];
        if (order !== undefined) {
            cartBlock.push(this.renderCartItems(orderCartInfo));
            cartBlock.push(this.renderUserInfo(order));
            if (typeof order.payment !== undefined && order.payment.commision) {
                cartBlock.push(this.renderPaymentCommision(order));
            }
            if (typeof order.delivery !== undefined) {
                cartBlock.push(this.renderDelivery(order));
            }
            cartBlock.push(this.renderTotal(orderCartInfo));
        }

        return (
            <table className="order-cart table table-hover">
                <thead>
                    <tr>
                        <th className="code" colSpan="2">Артикул</th>
                        <th className="name">Название</th>
                        <th className="count">Кол-во</th>
                        <th className="allocated">Резерв</th>
                        <th className="cost" style={{ textAlign: 'right' }}>C/C</th>
                        <th className="price" style={{ textAlign: 'center' }}>Цена</th>
                        <th className="discount" style={{ textAlign: 'center' }}>Скидка</th>
                        <th className="margin" style={{ textAlign: 'right' }}>Маржа</th>
                        <th className="subtotal" style={{ textAlign: 'right' }}>Итого</th>
                    </tr>
                </thead>
                <tbody>
                    {cartBlock}
                </tbody>
            </table>
        );
    }

    renderCartItems(orderCartInfo) {
        const cartItems = [];
        Object.values(orderCartInfo.items).map((cartItem, index) => {            
            cartItems.push(this.renderCartItem(cartItem, index));
        });
        
        return cartItems;
    } 

    renderCartItem(cartItem, index) {
        let availabilityClass;
        if (cartItem.goods_availible_for_order >= cartItem.amount) {
            availabilityClass = 'green';
        } else if (cartItem.goods_availible_for_order > 0 && cartItem.goods_availible_for_order < cartItem.amount) {
            availabilityClass = 'yellow';
        } else if (cartItem.goods_availible_for_order <= 0) {
            availabilityClass = 'red';
        }
        
        const currenciesForPrice = this.props.currencies.map((value) => {
            return { value: value.id, label: value.code };
        });

        const currenciesForDiscount = this.props.currencies.map((value) => {
            return { value: value.id, label: value.code };
        });
        currenciesForDiscount.push({ value: 0, label: '%' });
        
        return (
            <tr key={cartItem.id}>
                <td className="a">
                    <span className={availabilityClass} title={`Доступно для заказа (На складе/Резерв): ${cartItem.goods_availible_for_order} (${cartItem.goods_in_stock}/${cartItem.goods_reserve})`}></span>
                </td>
                <td className="code">{cartItem.code}</td>
                <td className="name">
                    <span className="eip" id={cartItem.id} style={{ borderBottom: '1px dashed #666' }}>
                        {cartItem.name}
                    </span>
                </td>
                <td className="count">
                    <Field
                        name={'cart.' + index + '.amount'}
                        value={cartItem.amount}
                        component="input"
                        type="text"
                        className="input-xmini"
                        onChange={this.props.onChange} /> 
                </td>
                <td className="allocated">
                    <Field
                        name={'cart.' + index + '.reserve'}
                        value={cartItem.reserve}
                        component="input"
                        type="text"
                        className="input-xmini"
                        onChange={this.props.onChange} />
                </td>
                <td className="cost" style={{ textAlign: 'right' }}>
                    {parseFloat(cartItem.cost_cur)}
                </td>
                <td className="price form-inline">
                    <Field
                        name={'cart.' + index + '.price_cur'}
                        value={cartItem.price_cur}
                        component="input"
                        type="text"
                        className="input-mini"
                        onChange={this.props.onChange} />
                        
                    <SelectField
                        name={'cart.' + index + '.price_cur_id'}
                        options={currenciesForPrice}
                        value={cartItem.price_cur_id}
                        placeholder=""
                        className="input-xsmall input-small-font"
                        onChange={this.props.onChange} />
                </td>
                <td className="discount form-inline">
                    <Field
                        name={'cart.' + index + '.price_discount'}
                        value={cartItem.price_discount}
                        component="input"
                        type="text"
                        className="input-xmini"
                        onChange={this.props.onChange} />

                    <SelectField
                        name={'cart.' + index + '.price_discount_type_id'}
                        options={currenciesForDiscount}
                        value={cartItem.price_discount_type_id}
                        placeholder=""
                        className="input-xsmall input-small-font"
                        onChange={this.props.onChange} />
                </td>
                <td className="margin" style={{ textAlign: 'right' }} style={{ color: cartItem.margin < 0 ? 'red' : 'inherit' }}>
                    {parseFloat(cartItem.margin)}
                </td>
                <td className="subtotal" style={{ textAlign: 'right' }}>
                    {parseFloat(cartItem.total)}
                </td>
            </tr>
        );
    }
    
    renderUserInfo(order) {
        const currenciesForPrice = this.props.currencies.map((value) => {
            return { value: value.id, label: value.code };
        });

        const currenciesForDiscount = this.props.currencies.map((value) => {
            return { value: value.id, label: value.code };
        });
        currenciesForDiscount.push({ value: 0, label: '%' });
        
        return (
            <tr key="user_discount" className="delivery">
                <td colSpan="7">
                    <label htmlFor="discount">Скидка покупателя</label>
		        </td>
                <td className="discount form-inline">          
                    <Field
                        name='discount'
                        component="input"
                        type="text"
                        className="input-xmini"
                        onChange={this.props.onChange} />

                    <SelectField
                        name='discount_type_id'
                        options={currenciesForDiscount}
                        className="input-mini input-small-font"
                        onChange={this.props.onChange} />
                </td>
                <td colSpan="2"></td>
            </tr>
        )
    }
    
    renderPaymentCommision(order) {
        return (
            <tr key="payment" className="delivery">
                <td colSpan="7" style={{ textAlign: 'right' }}>
                    <label htmlFor="payment_commision">Коммисия платежной системы</label>
			    </td>
                <td className="subtotal" style={{ textAlign: 'right' }}>
                    {order.payment.commision} %
			    </td>
            </tr>
        );
    }
    
    renderDelivery(order) {
        const currenciesForPrice = this.props.currencies.map((value) => {
            return { value: value.id, label: value.code };
        });
        
        return (
            <tr key="delivery" id="delivery_data" className="delivery">
                <td className="code" colSpan="2">
                    <label htmlFor="delivery_name">Доставка</label>
		        </td>
                <td colSpan="4" className="form-inline row">
                    <SelectField
                        name="delivery_id"
                        options={this.props.deliveries.map((value) => {
                            return { value: value.id, label: value.name };
                        })}
                        className="span6"
                        onChange={this.props.onChange} />

                    <Field
                        name='delivery_name'
                        component="input"
                        type="text"
                        className="span6"
                        onChange={this.props.onChange} />
		        </td>
                <td className="price form-inline">
                    <Field
                        name='delivery_price_cur'
                        component="input"
                        type="text"
                        className="input-mini"
                        onChange={this.props.onChange} />

                    <SelectField
                        name='delivery_price_cur_id'
                        options={currenciesForPrice}
                        className="input-xsmall input-small-font"
                        onChange={this.props.onChange} />
                </td>
                <td className="subtotal" colSpan="3" style={{ textAlign: 'right' }}>
                    {parseFloat(order.delivery_price_cur)}
		        </td>
	        </tr>
        );
    }

    renderTotal(orderCartInfo) {
        return (
            <tr key="total" className="total">
                <td colSpan="7">Общий итог</td>
                <td className="discount" style={{ textAlign: 'center' }}>
                    {parseFloat(orderCartInfo.saving)}
                    <br/>
                    ({parseFloat(orderCartInfo.discount)} %)
		        </td>
                <td className="margin" style={{ textAlign: 'right' }}>
                    {parseFloat(orderCartInfo.margin)}
		        </td>
                <td className="subtotal" style={{ textAlign: 'center' }}>
                    {parseFloat(orderCartInfo.total)}
		        </td>
            </tr>
        );
    }
}