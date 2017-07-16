import React, {Component, createElement} from 'react';
import {is} from 'immutable';

class FilterItem extends Component {

  render() {
    const { onFieldChange, filter } = this.props;

    return (
      <div className="filter-item">
        <div>{filter.get('displayName')}</div>
        {this.renderWidget()}
      </div>
    );
  }

  renderWidget() {
    const {filter, onOperatorChange, onValueChange} = this.props;
    const props = Object.assign({
      operator: filter.get('operator'),
      value: filter.get('value'),
      onOperatorChange,
      onValueChange
    }, filter.get('widgetOptions'));

    return createElement(filter.get('widget'), props);
  }
}

export default FilterItem;
