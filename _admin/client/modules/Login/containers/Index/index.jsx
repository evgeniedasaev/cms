import React, { PureComponent, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { browserHistory } from 'react-router';
import {Redirect} from 'react-router-dom';
import * as actions from '../../action';
import { Grid } from 'semantic-ui-react';
import LoginForm from '../../components/Form/index';

class LoginIndex extends PureComponent {
    componentDidMount() {
        this.setState({
            user: {
                login: null,
                passwd: null
            }
        })
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
        const {isLoggedIn} = this.props;       
        return (
            <Grid verticalAlign="middle" centered columns={1} textAlign="center" relaxed>
                {isLoggedIn && <Redirect to="/" />}
                {!isLoggedIn && 
                    <Grid.Row>
                        <Grid.Column tablet={10} mobile={16} computer={6}>
                            <LoginForm
                                onChange={this.updateFormState.bind(this)}
                                onSubmit={this.authentificate.bind(this)} /> 
                        </Grid.Column>
                    </Grid.Row>
                }
            </Grid>
        );
    }
}

export default connect(
    state => {return {
        isLoggedIn: state.auth.isLoggedIn
    }},
    dispatch => {
        return { actions: bindActionCreators(actions, dispatch) }
    }
)(LoginIndex);