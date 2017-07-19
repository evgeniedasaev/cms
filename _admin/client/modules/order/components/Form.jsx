import React, { PureComponent, PropTypes } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { Field, reduxForm, formValueSelector } from 'redux-form';

import OrderCartForm from './CartForm';

import TextField from '../../App/componentsformWidget/TextField';
import SelectField from '../../App/componentsformWidget/SelectField';
import BoxField from '../../App/componentsformWidget/BoxField';

class OrderForm extends PureComponent {

    render() {
        const { initialValues, currentValues, pristine, reset, submitting } = this.props;

        return (
            <form onSubmit={this.props.onSubmit} className="inner" style={{ marginBottom: '50px'   }}>
                <Field name="user_id" component="input" type="hidden" />

                <div className="row-fluid">
                    <div className="span4">
                        <TextField
                            fieldLable="Дата доставки"
                            name="dt_delivery"
                            component="input"
                            type="date"
                            placeholder=""
                            className="input-block-level"
                            onChange={this.props.onChange} />

                        <TextField
                            fieldLable="Время доставки"
                            name="dt_delivery_time_string"
                            component="input"
                            type="text"
                            placeholder=""
                            className="input-block-level"
                            onChange={this.props.onChange} />

                        <BoxField
                            fieldLable="Включить доставку"
                            name="delivery_id"
                            component="input"
                            type="checkbox"
                            placeholder=""
                            className="input-block-level"
                            onChange={this.props.onChange} />
                    </div>
                    <div className="span4">
                        <SelectField
                            fieldLable="Способ оплаты"
                            name="payment_id"
                            options={this.props.payments.map((value) => {
                                return { value: value.id, label: value.name };
                            })}
                            placeholder=""
                            className="input-block-level"
                            onChange={this.props.onChange} />

                        <SelectField
                            fieldLable="Статус оплаты"
                            name="payment_status_id"
                            options={this.props.paymentStatuses.map((value) => {
                                return { value: value.id, label: value.name };
                            })}
                            placeholder=""
                            className="input-block-level"
                            onChange={this.props.onChange} />                       
                    </div>
                    <div className="span4">
                        <SelectField
                            fieldLable="Статус заказа"
                            name="status_id"
                            options={this.props.orderStatuses.map((value) => {
                                return { value: value.id, label: value.name };
                            })}
                            placeholder=""
                            className="input-block-level"
                            onChange={this.props.onChange} />

                        <BoxField
                            fieldLable="Заказ завершён успешно"
                            name="is_success"
                            component="input"
                            type="checkbox"
                            placeholder=""
                            className="input-block-level"
                            onChange={this.props.onChange} />

                        <TextField
                            fieldLable="Комментарий менеджера"
                            name="auser_comment"
                            component="textarea"
                            placeholder=""
                            className="input-block-level"
                            style={{    height: '50px'  }}
                            onChange={this.props.onChange} />                    
                    </div>
                </div>
                <div className="row-fluid">
                    <fieldset className="span6">
                        <legend>Карточка заказа</legend>              
                        
                        <h4>Клиент</h4>
                        
                        <div className="row-fluid">
                            <div className="span6">
                                <BoxField
                                    fieldLable="Физическое лицо"
                                    name="business_entity"
                                    value="0"
                                    component="input"
                                    type="radio"
                                    placeholder=""
                                    className="input-block-level"
                                    checked={currentValues.businessEntity != 1}
                                    onChange={this.props.onChange} />
                            </div>
                            <div className="span6">
                                <BoxField
                                    fieldLable="Юридическое лицо"
                                    name="business_entity"
                                    value="1"
                                    component="input"
                                    type="radio"
                                    placeholder=""
                                    className="input-block-level"
                                    checked={currentValues.businessEntity == 1}
                                    onChange={this.props.onChange} />
                            </div>
                        </div>
                        
                        <TextField
                            fieldLable="Фамилия, Имя и Отчество"
                            name="user_name"
                            component="input"
                            type="text"
                            placeholder="ФИО"
                            className="w title"
                            onChange={this.props.onChange} />

                        <TextField
                            fieldLable="Телефон"
                            name="phone" 
                            component="input"
                            type="text"
                            placeholder="Телефон"
                            className="input-block-level customer_suggest maskedinput_phone"
                            autoComplete="off"
                            data-filter-field="phone"
                            onChange={this.props.onChange} />
                        
                        <TextField
                            fieldLable="Телефон (дополнительный)"
                            name="phone_2"
                            component="input"
                            type="text"
                            placeholder="Телефон"
                            className="input-block-level customer_suggest maskedinput_phone"
                            autoComplete="off"
                            data-filter-field="phone"
                            onChange={this.props.onChange} />

                        <TextField
                            fieldLable="E-mail"
                            name="email"
                            component="input"
                            type="email"
                            placeholder="Email"
                            className="input-block-level customer_suggest"
                            autoComplete="off"
                            data-filter-field="email"
                            onChange={this.props.onChange} />
                            
                        { currentValues.businessEntity == 1 &&
                            <div style={{   marginTop: '20px'    }}>
                                <TextField
                                    fieldLable="Компания"
                                    name="company"
                                    component="input"
                                    type="text"
                                    placeholder="Компания"
                                    className="input-block-level"
                                    onChange={this.props.onChange} />

                                <TextField
                                    fieldLable="Почтовый индекс"
                                    name="postalcode"
                                    component="input"
                                    type="text"
                                    placeholder="Почтовый индекс"
                                    className="input-block-level"
                                    onChange={this.props.onChange} />

                                <TextField
                                    fieldLable="Юридический адрес"
                                    name="legal_address"
                                    component="input"
                                    type="text"
                                    placeholder="Юридический адрес"
                                    className="input-block-level"
                                    onChange={this.props.onChange} />

                                <TextField
                                    fieldLable="ИНН"
                                    name="INN"
                                    component="input"
                                    type="text"
                                    placeholder="ИНН"
                                    className="input-block-level"
                                    onChange={this.props.onChange} />

                                <TextField
                                    fieldLable="КПП"
                                    name="KPP"
                                    component="input"
                                    type="text"
                                    placeholder="КПП"
                                    className="input-block-level"
                                    onChange={this.props.onChange} />

                                <TextField
                                    fieldLable="БИК"
                                    name="BIK"
                                    component="input"
                                    type="text"
                                    placeholder="БИК"
                                    className="input-block-level"
                                    onChange={this.props.onChange} />

                                <TextField
                                    fieldLable="Корр. счет"
                                    name="corr_account"
                                    component="input"
                                    type="text"
                                    placeholder="Корр. счет"
                                    className="input-block-level"
                                    onChange={this.props.onChange} />

                                <TextField
                                    fieldLable="Расчетный счет"
                                    name="giro_account"
                                    component="input"
                                    type="text"
                                    placeholder="Расчетный счет"
                                    className="input-block-level"
                                    onChange={this.props.onChange} />
                        
                            </div>                        
                        }
                        
                        <div style={{ marginTop: '20px' }}>
                            <TextField
                                fieldLable="Метро"
                                name="subway"
                                component="input"
                                type="text"
                                placeholder="Метро"
                                className="input-block-level"
                                onChange={this.props.onChange} />

                            <TextField
                                fieldLable="Адрес"
                                name="address"
                                component="textarea"
                                placeholder="Адрес"
                                className="input-block-level"
                                style={{ height: '50px' }}
                                onChange={this.props.onChange} />

                            <TextField
                                fieldLable="Как проехать"
                                name="directions"
                                component="textarea"
                                placeholder="Как проехать"
                                className="input-block-level"
                                style={{ height: '50px' }}
                                onChange={this.props.onChange} />

                            <TextField
                                fieldLable="Комментарий"
                                name="comment"
                                component="textarea"
                                placeholder="Комментарий"
                                className="input-block-level"
                                style={{ height: '50px' }}
                                onChange={this.props.onChange} /> 
                        </div>
                    </fieldset>
                </div>
                
                <div className="row-fluid">
                    <fieldset className="span12">
                        <legend>
                            Товары     <Link to={'/_admin/order/add_cart_item/' + this.props.params.id} className="btn btn-small">
                                Добавить товар
                            </Link>
                        </legend>
                        
                        <OrderCartForm {...this.props} />
                    </fieldset>
                </div>

                <button type="submit" className="btn" disabled={submitting}>Сохранить</button>
            </form>
        );
    }
};

let orderForm = reduxForm({
    form: 'orderEdit',
    enableReinitialize: true,
    destroyOnUnmount: false
})(OrderForm);

const formSelector = formValueSelector('orderEdit');

orderForm = connect(
    (state, props) => {
        return {
            ...props,
            currentValues: {
                businessEntity: formSelector(state, 'business_entity')
            }
        }
    }
)(orderForm);

export default orderForm;