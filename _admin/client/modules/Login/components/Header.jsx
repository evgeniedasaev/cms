import React, { PureComponent, PropTypes } from 'react';
import { Link } from 'react-router';

import Navigation from './Navigation';
import UserPanel from './UserPanel';

export default class Header extends PureComponent {

    render() {
        return (
            <header id="header">
                <Navigation {...this.props}/>
                <div className="navbar navbar-static-top" id="head-navbar">
                    <div className="navbar-inner">
                        <a className="logo">
                            <img src={this.props.logo} />
                        </a>
                        <a className="brand" href="#">{this.props.title}</a>
                        {   this.props.loggedIn &&
                            <UserPanel
                                id={this.props.userId}
                                title={this.props.userTitle}
                                company={this.props.userCompany}
                                position={this.props.userPosition}
                                logout={this.props.actions.logout}
                            />
                        }
                        <div className="btn-toolbar pull-right" style={{ margin: "7px 0 0 15px" }}>
                            {/*head-toolbar*/}
                        </div>
                        <div className="btn-toolbar pull-right" style={{ margin: "7px 0 0 15px" }}>
                            {/*header-toolbar*/}
                        </div>
                    </div>
                </div>
            </header>
        );
    }
}