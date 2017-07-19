import React, {Component, createElement} from 'react';
import Select from 'react-select';

import { debounce } from './debounce';

const SEARCH_DELAY = 200;

function contains(haystack, needle) {
  return haystack.toLowerCase().indexOf(needle) !== -1;
}

class MultiSelect extends Component {
  constructor(props) {
    super(props);
    this.state = {options: props.options};
    this.renderOptions.bind(this);
  }

  render() {
    return (
      <div className="multi-select">
        <Select
          placeholder=""
          multi={true}
          options={this.renderOptions()}
          value={this.props.value}
          className="input-block-level"
          onChange={this.onChange.bind(this)} />
      </div>
    );
  }

  renderOptions() {
    let options = [];
    this.props.options.map(({key, value}) => {
      options.push({ value: key, label: value });
    });
    return options;
  }

  onChange(selected) {
    this.props.onChange(selected.map((option) => option.value));
  }
}

export default MultiSelect;
