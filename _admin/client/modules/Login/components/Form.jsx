import React, { PureComponent, PropTypes } from 'react';
import { reduxForm } from 'redux-form';

import { Form, Message, Grid } from 'semantic-ui-react'
import { TextCenter } from '../../../styles/base.jsx';
import { LoginButton } from '../style';

class LoginForm extends PureComponent {

    render() {
        const { initialValues, currentValues, pristine, reset, submitting } = this.props;
        const username = '';
        const password = '';
        const errors = [];
        const loginFormProps = {
            error: null
        };
        const loginBtnProps = {
            content: 'Войти',
            icon: 'sign in'
        };

        return (
            <Grid verticalAlign="middle" centered columns={1} textAlign="center" relaxed>
                <Grid.Row>
                    <Grid.Column tablet={10} mobile={16} computer={6}>
                        <Form onSubmit={this.props.onSubmit} {...loginFormProps}>
                        {errors &&
                            <Message
                            error
                            header={'Invalid credentials'}
                            content={'Your credentials are invalid.'}
                            />}
                        <Form.Input
                            placeholder="Логин"
                            name="username"
                            label="Логин"
                            value={username}
                            onChange={this.props.onChange}
                        />
                        <Form.Input
                            placeholder="Пароль"
                            type="password"
                            name="password"
                            label="Пароль"
                            value={password}
                            onChange={this.props.onChange}
                        />
                        <TextCenter>
                            <LoginButton {...loginBtnProps} />
                        </TextCenter>
                        </Form>
                    </Grid.Column>
                </Grid.Row>
            </Grid>
        );
    }
};

export default reduxForm({
    form: 'authLogin',
    enableReinitialize: true,
    destroyOnUnmount: false
})(LoginForm);