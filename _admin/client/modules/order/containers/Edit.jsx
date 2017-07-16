import React, { PureComponent, PropTypes } from 'react';
import { Link, browserHistory } from 'react-router';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { StickyContainer, Sticky } from 'react-sticky-modified';
import dateFormat from 'dateformat';

import * as actions from '../action';

import Header from '../../../components/Header';
import OrderSidebar from '../components/Sidebar';
import OrderForm from '../components/Form';

import {
    scope,
    orderById,
    extendedCart,
    orderStatuses,
    payments,
    paymentStatuses,
    deliveries,
    currencies,
    baseCurrency
} from '../selector';

class OrderEdit extends PureComponent {

    constructor(props, context) {
        super(props, context);
        
        this.saveOrder = this.saveOrder.bind(this);
        this.updateOrderState = this.updateOrderState.bind(this);
    }
    
    initOrder(scope, orderProps) {
        this.setState({ order: { ...orderProps } });

        this.props.actions.updateOrderCart(scope, orderProps);
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.order !== undefined && (this.props.order === undefined || this.props.order.id != nextProps.order.id)) {           
            this.initOrder(this.props.scope.crud, nextProps.order);
        }
    }

    componentDidMount() {        
        if (typeof this.props.order === 'undefined' && this.props.params.id) {
            this.props.actions.fetchOrder(this.props.scope.crud, this.props.params.id);
        }
        
        if (typeof this.props.order !== 'undefined') {            
            this.initOrder(this.props.scope.crud, this.props.order);
        }
    }
    
    setToValue(obj, value, path) {
        var i;
        path = path.split('.');
        for (i = 0; i < path.length - 1; i++)
            obj = obj[path[i]];

        obj[path[i]] = value;
    }

    updateOrderState(event) {    
        const orderData = { ...this.state.order };

        this.setToValue(orderData, event.target.value, event.target.name);

        this.initOrder(this.props.scope.crud, orderData);
    }

    saveOrder(event) {
        event.preventDefault();

        this.props.actions.updateOrder(this.props.scope.crud, this.state.order);
    }

    render() {
        return (
            <div className="row-fluid">
                <div className="span9 pane">
                    <StickyContainer className="container-fluid pane-content">
                        <Sticky>
                            <Header title={`Заказ №${this.props.params.id}`} />
                        </Sticky>
                        <OrderForm
                            {...this.props}
                            initialValues={{...this.props.order}}
                            onChange={this.updateOrderState}
                            onSubmit={this.saveOrder} />
                    </StickyContainer>
                </div>
                <div className="span3 pane sidebar">
                    {
                        this.props.order &&
                        <OrderSidebar {...this.props} />
                    }
                </div>
            </div>
        );
    }
}

function mapStateToProps(state, props) {
    props = { ...props, moduleName: 'edit'};

    return {
        scope: scope(state, props),
        order: orderById(state, props),
        orderCart: extendedCart(state, props),
        
        orderStatuses: orderStatuses(state, props),
        payments: payments(state, props),
        paymentStatuses: paymentStatuses(state, props),
        deliveries: deliveries(state, props),
        currencies: currencies(state, props),
        
        baseCurrency: baseCurrency(state, props)              
    };
}

function mapDispatchToProps(dispatch) {
    return { actions: bindActionCreators(actions, dispatch) };
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderEdit);