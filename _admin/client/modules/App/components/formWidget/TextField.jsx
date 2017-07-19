import React, { PropTypes, Component } from 'react';
import { Field, reduxForm } from 'redux-form';

export default class TextField extends Component {

    render() {
        let { fieldLable: fieldLable, ...fieldProp } = this.props;

        if (typeof fieldLable !== 'undefined') {
            return (
                <div>
                    <label htmlFor={fieldProp.name}>{fieldLable}</label>
                    <div>
                        <Field {...fieldProp}>
                            {this.props.children}
                        </Field>
                    </div>
                </div>
            );
        } else {
            return (
                <Field {...fieldProp }>
                    { this.props.children }
                </Field >
            );            
        }
    }
}