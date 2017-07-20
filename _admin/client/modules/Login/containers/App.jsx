import React, { PureComponent, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Link } from 'react-router';
import { browserHistory } from 'react-router';

import * as actions from '../action';

import Header from '../components/Header';

class App extends PureComponent {

    static propTypes = {
        children: PropTypes.object.isRequired
    }

    componentDidMount() {
        const { isLoggedIn, userId, appInfoLoaded } = this.props;

        if (isLoggedIn && typeof userId !== 'undefined' && !appInfoLoaded) {
            this.props.actions.fetchAppInfo(userId);
        }
    }
    
    componentWillReceiveProps(nextProps) {
        const { isLoggedIn } = nextProps;

        if (!isLoggedIn) {
            browserHistory.push('/_admin/login');
        }
    }    

    render() {       
        return (
            <div id="wrapper">
                <Header {...this.props} />
                {this.props.children}
            </div>
        );
    }
}

export default connect((state, props) => {
    return {
        ...state.application,
        currentPathname: props.router.location.pathname
    };
}, (dispatch) => {
    return { actions: bindActionCreators(actions, dispatch) }
})(App);