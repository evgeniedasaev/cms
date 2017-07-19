import React from 'react';
import DefaultWidget from './DefaultWidget';
import dateFormat from 'dateformat';
import * as operators from './operators';

class DateWidget extends DefaultWidget {
  getOperators() {
    return {
      [operators.EQUALS]: 'on',
      [operators.GREATER_THAN]: 'after',
      [operators.LESS_THAN]: 'before',
      [operators.BETWEEN]: 'between',
      [operators.NOT_BETWEEN]: 'not between'
    };
  }

  renderInputElement(value, onChange) {
    const dateAsString = value ? dateFormat(value, 'isoDate') : '';
    const onChangeWithDate = (e) => {
      const stringValue = e.target.value;
      onChange(stringValue === '' ? '' : new Date(stringValue));
    };

    return <input type="date" className="input-block-level" value={dateAsString} onChange={onChangeWithDate} />;
  }
}

DateWidget.defaultOperator = operators.EQUALS;
DateWidget.defaultValue = '';

export default DateWidget;
