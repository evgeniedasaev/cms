import React, { PureComponent, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { browserHistory } from 'react-router';

class Root extends PureComponent {

    static propTypes = {
        children: PropTypes.object.isRequired
    }

    componentWillReceiveProps(nextProps) {
        const { loggedIn, nextPathname } = nextProps;

        if (loggedIn && typeof nextPathname !== 'undefined') {
            browserHistory.push(nextPathname);
        }

        if (!loggedIn) {
            browserHistory.push('/_admin/login');
        }
    }

    render() {
        return (
            <div>{this.props.children}</div>
        );
    }
}

export default connect((state, props) => {
    return {
        loggedIn: state.application.loggedIn,
        nextPathname: (typeof props.location.state !== 'undefined') ? props.location.state.nextPathname : undefined
    }
}, null)(Root);