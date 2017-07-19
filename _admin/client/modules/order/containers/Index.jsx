import React, { PureComponent, PropTypes, createElement } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { StickyContainer, Sticky } from 'react-sticky-modified';
import { ModalManager } from 'react-dynamic-modal';

import Header from '../../App/componentsHeader';
import OrderList from '../components/List';
import OrderFilter from '../components/Filter';

import MassAction from '../../App/componentsMassAction';
import Modal from '../../App/componentsModal';

import * as actions from '../action';

import {
    scope,
    orders,
    page,
    hasMore,
    loading,
    filter,
    baseCurrency,
    selectedOrders,
    selectedAction,
    massActions,
    orderStatuses,
    ausers
} from '../selector';

class OrderIndex extends PureComponent {

    componentWillReceiveProps(nextProps) {
        if (nextProps.selectedAction !== null) {
            this.openModal(nextProps.selectedAction);
        } else {
            ModalManager.close();
        }
    }
    
    renderMassActionWidget(massAction, ids) {
        let list;
        switch (massAction.code) {
            case 'CHANGE_STATUS':
                list = this.props.orderStatuses;

                break;
            case 'ASSIGN_MANAGER':
                list = this.props.ausers;
                
                break;
        }
        
        let processAction;
        switch (massAction.code) {
            case 'CHANGE_STATUS':
                processAction = this.props.actions.changeStatusManager;

                break;
            case 'ASSIGN_MANAGER':
                processAction = this.props.actions.assignManager;
                
                break;
        }

        return createElement(massAction.widget, {
            list,
            onSubmit: (selectedId) => {
                processAction(null, ids, selectedId);
                
                this.props.actions.clear(this.props.scope.massAction);
            }
        });
    }

    openModal(action) {
        const { selectedOrders } = this.props;
        const selectedAction = this.props.massActions.filter(
            actionObject => actionObject.code == action
        )[0];
        
        ModalManager.open(
            <Modal
                header={selectedAction.name}
                onClose={() => this.props.actions.clear(this.props.scope.massAction)}
            >
                {this.renderMassActionWidget(selectedAction, selectedOrders)}
            </Modal>
        );
    }

    render() {        
        return (
            <div className="row-fluid">
                <div className="span12">
                    <StickyContainer className="pane-content">
                        <Sticky>
                            <Header title="Заказы" showFilterToggler="true" />
                        </Sticky>
                        <div className="inner">
                            <div className="row-fluid">
                                <OrderFilter moduleName="single" {...this.props} />
                                <OrderList moduleName="single" {...this.props} />
                            </div>
                        </div>
                        {
                            this.props.selectedOrders.length &&
                            <MassAction
                                ids={this.props.selectedOrders}
                                action={this.props.selectedAction}
                                actionList={this.props.massActions}
                                checksum={this.props.selectedOrders.join()}
                                onSelectAction={(action) => this.props.actions.selectAction(this.props.scope.massAction, action.value)}
                            />
                        }
                    </StickyContainer>
                </div>
            </div>
        );
    }
}

function mapStateToProps(state, props) {
    props = { ...props, moduleName: 'single' };
    
    return {
        scope: scope(state, props),
        orders: orders(state, props),

        page: page(state, props),
        hasMore: hasMore(state, props),
        loading: loading(state, props),

        filter: filter(state, props),
        baseCurrency: baseCurrency(state, props),
        
        orderStatuses: orderStatuses(state, props),
        ausers: ausers(state, props),

        selectedOrders: selectedOrders(state, props),
        selectedAction: selectedAction(state, props),
        massActions: massActions(state, props)
    };
}

function mapDispatchToProps(dispatch) {
    return { actions: bindActionCreators(actions, dispatch) };
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderIndex);