import React, { PureComponent, PropTypes } from 'react';
import { reduxForm } from 'redux-form';

import TextField from '../../../components/formWidget/TextField';

class LoginForm extends PureComponent {

    render() {
        const { initialValues, currentValues, pristine, reset, submitting } = this.props;

        return (
            <form onSubmit={this.props.onSubmit} className="inner" style={{ marginTop: '25%', marginBottom: '50px' }}>
                <div className="row-fluid">
                    <div className="span4"></div>
                    <div className="span4">
                        <TextField
                            fieldLable="Логин"
                            name="login"
                            component="input"
                            type="text"
                            placeholder=""
                            className="input-block-level"
                            onChange={this.props.onChange} />

                        <TextField
                            fieldLable="Пароль"
                            name="passwd"
                            component="input"
                            type="password"
                            placeholder=""
                            className="input-block-level"
                            onChange={this.props.onChange} />
                            
                        <button type="submit" className="btn" disabled={submitting}>Авторизоваться</button>
                    </div>
                    <div className="span4"></div>
                </div>
            </form>
        );
    }
};

export default reduxForm({
    form: 'authLogin',
    enableReinitialize: true,
    destroyOnUnmount: false
})(LoginForm);