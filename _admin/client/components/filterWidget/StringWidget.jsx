import React from 'react';
import DefaultWidget from './DefaultWidget';
import * as operators from './operators';

class StringWidget extends DefaultWidget {
  getOperators() {
    return {
      [operators.CONTAINS]: 'contains',
      [operators.DOES_NOT_CONTAIN]: 'doesn\'t contains',
      [operators.EQUALS]: 'is',
      [operators.NOT_EQUALS]: 'is not'
    };
  }

  renderInputElement(value, onChange) {
    return <input type="text" className="input-block-level" value={value} onChange={(e) => onChange(e.target.value)} />;
  }
}

StringWidget.defaultOperator = operators.CONTAINS;
StringWidget.defaultValue = '';

export default StringWidget;
