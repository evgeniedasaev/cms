import React, { PropTypes, Component } from 'react';
import { Field, reduxForm } from 'redux-form';

export default class BoxField extends Component {

    render() {
        let { fieldLable: fieldLable, ...fieldProp } = this.props;

        return (
            <div>
                <label htmlFor={fieldProp.name}>
                    <Field {...fieldProp} style={{
                        display: 'inline-block',
                        minHeight: 'initial',
                        width: '5%',
                        marginTop: '0px',
                        marginRight: '2.5%'
                    }}>
                        {this.props.children}
                    </Field>
                    <span style={{ width: '90%', }}>
                        {fieldLable}
                    </span>
                </label>
            </div>
        );
    }
}