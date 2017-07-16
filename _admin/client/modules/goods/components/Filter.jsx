import React, { PureComponent, PropTypes } from 'react';

import FilterItem from '../../../components/filterWidget/FilterItem';

export default class GoodsFilter extends PureComponent {

    static propTypes = {
        filter: PropTypes.object.isRequired
    };

    constructor(props) {
        super(props);

        this.updateList.bind(this);
    }

    updateList(filterId, value) {
        const filter = this.props.filter.setIn([filterId, 'value'], value);

        this.props.actions.changeFilterValue(this.props.scope.add_product.filter, filterId, value);

        this.props.actions.fetchGoods(this.props.scope.add_product.list, filter, 1);
    }

    renderItem(filter, filterId) {
        return (
            <div className='span2' key={filterId}>
                <FilterItem
                    key={filterId}
                    filter={filter}
                    onValueChange={(value) => this.updateList(filterId.toString(), value)} />
            </div>
        );
    }

    render() {
        if (this.props.filter.isEmpty()) return null;

        const 
            colSize = 2, 
            maxRowWidth = 12, 
            maxFilterInChunk = maxRowWidth/colSize,
            filterChunks = [];
        
        let chunkNum = 0;
        this.props.filter.map((filter, filterId) => {
            if (!(chunkNum in filterChunks)) {
                filterChunks[chunkNum] = [];
            }
            
            filterChunks[chunkNum].push(filter);
            
            if (filterId == maxFilterInChunk - 1) {
                ++chunkNum;
            }
        })

        return (
            <div className="well" id="filter">                
                {filterChunks.map((filters, chunkId) => {
                    return (
                        <div className="row-fluid" key={chunkId}>
                            {filters.map(this.renderItem.bind(this))}
                        </div>
                    );
                })}
            </div>
        );
    }
}