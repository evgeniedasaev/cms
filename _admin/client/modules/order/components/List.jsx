import React, { PureComponent, PropTypes } from 'react';
import InfiniteScroll from 'react-infinite-scroller';

import OrderPreview from './Preview';

export default class OrderList extends PureComponent {

    static propTypes = {
        orders: PropTypes.array.isRequired,
        page: PropTypes.number,
        hasMore: PropTypes.bool,
        children: PropTypes.object
    };

    constructor(props) {
        super(props);

        this.renderMessages.bind(this);
    }

    loadMore(pageNum) {
        if (!this.props.loading) {
            this.props.actions.fetchOrders(this.props.scope.list, this.props.filter, pageNum);
        }
    }

    renderMessages() {
        let orderList = [];
        let { orders, selectedOrders, baseCurrency, scope, actions: { selectOrder } } = this.props;

        orders.forEach(function (order) {
            orderList.push(<OrderPreview key={order.id} order={order} selected={selectedOrders.indexOf(order.id) >= 0} baseCurrency={baseCurrency} onChange={selectOrder.bind(null, scope.massAction, order.id)} />);
        });

        return orderList;
    }

    render() {
        return (
            <InfiniteScroll 
                pageStart={this.props.page}
                hasMore={this.props.hasMore}
                threshold={2500}
                loader={<div className="loader">Loading ...</div>}
                loadMore={this.loadMore.bind(this)}
                className="container-fluid">
                { this.renderMessages() }
            </InfiniteScroll>
        );
    }
};
