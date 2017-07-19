import React, { PropTypes, Component } from 'react';
import { Field, reduxForm } from 'redux-form';
import Select from 'react-select';

import TextField from './TextField';

export default class SelectField extends Component {

    render() {
        let emptyValue = {
            value: 0,
            label: "Не выбрано",
            clearableValue: false
        };

        return (
            <TextField
                {...this.props}
                component={(field) => {
                    return (
                        <Select 
                            {...field.input}
                            placeholder=""
                            options={this.props.options}
                            value={field.input.value || emptyValue}
                            resetValue={emptyValue}
                            onChange={(value) => {
                                return field.input.onChange({
                                    ...value,
                                    target: {
                                        name: field.input.name,
                                        value: (value) ? value.value : value
                                    }
                                });
                            }} />
                    )
                }} />
        );
    };
}