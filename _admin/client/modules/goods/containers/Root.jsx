import React, { PureComponent, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import * as actions from '../action';

import { scope } from '../selector';

class OrderRoot extends PureComponent {

    componentDidMount() {
        if (!this.props.colleсtionsLoaded) {
            this.props.actions.fetchCollections(this.props.scope.collections);
        }
    }

    render() {
        return (
            <div>{this.props.children}</div>
        );
    }
}

function mapStateToProps(state, props) {
    return {
        colleсtionsLoaded: state.ordersModule.orderAddProduct.collections.colleсtionsLoaded,
        scope: scope(state, props)
    };
}

function mapDispatchToProps(dispatch) {
    return { actions: bindActionCreators(actions, dispatch) };
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderRoot);