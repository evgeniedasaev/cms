import React, { PureComponent, PropTypes } from 'react';
import { reduxForm } from 'redux-form';
import { Form } from 'semantic-ui-react';
import { TextCenter } from '../../../App/styles/base';
import { LoginButton } from './style';

class LoginForm extends PureComponent {
    static propTypes = {
        onChange: PropTypes.func.isRequired,
        onSubmit: PropTypes.func.isRequired
    }

    render() {
        const { onChange, onSubmit } = this.props;

        const loginBtnProps = {
            content: 'Войти',
            icon: 'sign in'
        };

        return (
            <Form onSubmit={onSubmit}>
                <Form.Input
                    placeholder="Логин"
                    name="login"
                    onChange={onChange}
                />
                <Form.Input
                    placeholder="Пароль"
                    type="password"
                    name="passwd"
                    onChange={onChange} 
                />
                <TextCenter>
                     <LoginButton {...loginBtnProps} /> 
                </TextCenter>
            </Form>
        );
    }
};

export default reduxForm({
    form: 'authLogin',
    enableReinitialize: true,
    destroyOnUnmount: false
})(LoginForm);