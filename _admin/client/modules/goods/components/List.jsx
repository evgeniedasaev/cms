import React, { PureComponent, PropTypes } from 'react';
import InfiniteScroll from 'react-infinite-scroller';

import GoodsPreview from './Preview';

export default class GoodsList extends PureComponent {

    static propTypes = {
        goods: PropTypes.array.isRequired,
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
            this.props.actions.fetchGoods(this.props.scope.add_product.list, this.props.filter, pageNum);
        }
    }

    renderMessages() {
        const props = this.props, goodsList = [], { goods } = this.props;

        goods.forEach(function (good) {
            goodsList.push(<GoodsPreview
                {...props}
                key={good.id}
                goods={good}
            />);
        });

        return goodsList;
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
                {this.renderMessages()}
            </InfiniteScroll>
        );
    }
};
