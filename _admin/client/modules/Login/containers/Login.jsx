import React, { PureComponent, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { browserHistory } from 'react-router';

import * as actions from '../action';

import LoginForm from '../components/Form';

class Login extends PureComponent {

    constructor(props, context) {
        super(props, context);

        this.authentificate = this.authentificate.bind(this);
        this.updateFormState = this.updateFormState.bind(this);
    }

    componentDidMount() {
        this.setState({
            user: {
                login: null,
                passwd: null
            }
        });
    }

    componentWillReceiveProps(nextProps) {
        const { loggedIn, nextPathname } = nextProps;
        console.log(loggedIn, nextPathname);
        if (loggedIn) {
            if (typeof nextPathname !== 'undefined') {
                browserHistory.push(nextPathname);
            } else {
                browserHistory.goBack();
            }
        }
    }

    updateFormState(event) {
        this.setState({
            user: {
                ...this.state.user,
                [event.target.name]: event.target.value
            }
        });
    }

    authentificate(event) {
        event.preventDefault();

        this.props.actions.logon(this.state.user);
    }

    render() {        
        return (
            <LoginForm
                onChange={this.updateFormState}
                onSubmit={this.authentificate} />
        );
    }
}

export default connect((state, props) => {
    return {
        loggedIn: state.application.loggedIn,
        nextPathname: (typeof props.location.state !== 'undefined') ? props.location.state.nextPathname : undefined
    }
}, (dispatch) => {
    return { actions: bindActionCreators(actions, dispatch) }
})(Login);