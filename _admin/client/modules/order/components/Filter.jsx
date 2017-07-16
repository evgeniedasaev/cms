import React, { PureComponent, PropTypes } from 'react';

import FilterItem from '../../../components/filterWidget/FilterItem';

export default class OrderFilter extends PureComponent {

    static propTypes = {
        filter: PropTypes.object.isRequired
    };

    constructor(props) {
        super(props);

        this.updateList.bind(this);
    }

    updateList(filterId, value) {
        const filter = this.props.filter.setIn([filterId, 'value'], value);
        
        this.props.actions.changeFilterValue(this.props.scope.filter, filterId, value);

        this.props.actions.fetchOrders(this.props.scope.list, filter, 1);
    }

    renderItem([filterId, filter]) {
        return (
            <div className="span2" key={filterId}>
                <FilterItem
                    key={filterId}
                    filter={filter}
                    onValueChange={(value) => this.updateList(filterId, value)} />
            </div>
        );
    }

    render() {
        if (this.props.filter.isEmpty()) return null;

        return (
            <div className="well" id="filter">
                <div className="row-fluid">             
                    {this.props.filter.entrySeq().map(this.renderItem.bind(this))}
                </div>
            </div>
        );
    }
}