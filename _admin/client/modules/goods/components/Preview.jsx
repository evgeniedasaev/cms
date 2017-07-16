import React, { PureComponent, PropTypes } from 'react';

export default class GoodsPreview extends PureComponent {

    addToOrder(event, order, goods) {
        event.preventDefault();

        this.props.actions.updateOrderProduct(this.props.scope.crud, order.id, goods.id);
    }

    render() {
        const { order, goods, baseCurrency } = this.props;

        return (
            <div className="row-fluid" key={goods.id} style={{  marginTop: '10px'   }}>
                <div className="span2">
                    <button onClick={(e) => this.addToOrder(e, order, goods)} className="btn">
                        Добавить в заказ
                    </button>
                </div>
                <div className="span1">{goods.code}</div>
                <div className="span9">
                    {goods.type_prefix_title + ' ' + goods.model}
                </div>
            </div>
        );
    };
};
