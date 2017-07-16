import React, { PureComponent, PropTypes } from 'react';
import RawHtml from "react-raw-html";

export default class OrderSidebar extends PureComponent {

    render() {
        return (            
            <div className="pane-content">             
                <div className="task-section">
                    <h4>Даты</h4>
                    {
                        this.props.order.dt_human &&
                        <dl className="task-detail">
                            <dt>Оформлен:</dt>
                            <dd>{this.props.order.dt_human}</dd>
                        </dl>
                    }
                    {
                        this.props.order.dt_create_human &&
                        <dl className="task-detail">
                            <dt>Создан:</dt>
                            <dd>{this.props.order.dt_create_human}</dd>
                        </dl>
                    }
                    {
                        this.props.order.dt_update_human &&
                        this.props.order.dt_update_human != this.props.order.dt_create_human &&
                        <dl className="task-detail">
                            <dt>Изменен:</dt>
                            <dd>{this.props.order.dt_update_human}</dd>
                        </dl>
                    }
                    <dl className="task-detail">
                        <dt>Способ оформления:</dt>
                        <dd>{this.props.order.referer}</dd>
                    </dl>
                </div>

                <div className="task-section">
                    <h4>Участники</h4>
                    {
                        this.props.order.auser_title &&
                        <dl className="task-detail">
                            <dt>Ответственный:</dt>
                            <dd>{this.props.order.auser_title}</dd>
                        </dl>
                    }
                    {
                        !parseInt(this.props.order.auser_id) &&
                        <a 
                            href={this.props.order.auser_assign}
                            id="order-assign-manager"
                            data-confirm="Вы уверены, что хотите стать менеджером этого заказа?"
                            className="btn btn-small">
                            Взять заказ
                        </a>
                    }
                </div>

                <div className="task-section">
                    <h4>Финансы</h4>
                    {
                        this.props.order.paid_for > 0 &&
                        typeof this.props.baseCurrency !== 'undefined' &&
                        <dl className="task-detail">
                            <dt>Оплачен на:</dt>
                            <RawHtml.dd>{parseFloat(this.props.order.paid_for).toLocaleString('ru-RU', { style: 'currency', currency: this.props.baseCurrency.code })}</RawHtml.dd>
                        </dl>
                    }
                    {
                        this.props.order.total > 0 &&
                        typeof this.props.baseCurrency !== 'undefined' &&
                        <dl className="task-detail">
                            <dt>Сумма заказа:</dt>
                            <RawHtml.dd>{parseFloat(this.props.order.total).toLocaleString('ru-RU', { style: 'currency', currency: this.props.baseCurrency.code })}</RawHtml.dd>
                        </dl>
                    }
                </div>
            </div>
        );
    }
}