import React, { PureComponent, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { StickyContainer, Sticky } from 'react-sticky-modified';

import Header from '../../App/componentsHeader';
import GoodsList from '../../goods/components/List';
import GoodsFilter from '../../goods/components/Filter';

import * as orderActions from '../action';
import * as goodsActions from '../../goods/action';

import {
    scope,
    orderById,
    baseCurrency
} from '../selector';

import {
    addProductPage,
    addProductHasMore,
    addProductLoading,
    goods,
    categories,
    brands,
    goodsTypes,
    filter
} from '../selector/add_product';

class OrderAddProduct extends PureComponent {

    componentDidMount() {
        if (typeof this.props.order === 'undefined' && this.props.params.id) {
            this.props.actions.fetchOrder(this.props.scope.crud, this.props.params.id);
        }
    }

    render() {
        return (
            <div className="row-fluid">
                <div className="span12">
                    <StickyContainer className="pane-content">
                        <Sticky>
                            <Header title={'Добавить товар в заказ №' + this.props.params.id} showFilterToggler="true" />
                        </Sticky>
                        <div className="inner">
                            <div className="row-fluid">
                                <GoodsFilter {...this.props} />
                                <GoodsList {...this.props} />
                            </div>
                        </div>
                    </StickyContainer>
                </div>
            </div>
        );
    }
}

function mapStateToProps(state, props) {
    props = { ...props, moduleName: 'edit' };
    
    return {
        scope: scope(state, props),
        order: orderById(state, props),
        goods: goods(state, props),

        page: addProductPage(state, props),
        hasMore: addProductHasMore(state, props),
        loading: addProductLoading(state, props),

        filter: filter(state, props),
        baseCurrency: baseCurrency(state, props),
        
        categories: categories(state, props),
        brand: brands(state, props),
        goodsTypes: goodsTypes(state, props)
    };
}

function mapDispatchToProps(dispatch) {
    return { actions: bindActionCreators({
        ...orderActions,
        ...goodsActions
    }, dispatch) };
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderAddProduct);