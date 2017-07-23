import React, { PureComponent, PropTypes } from 'react';
import { Link } from 'react-router';
import storage from '../../../storage.js';

export default class UserPanel extends PureComponent {

    logout(event) {
        event.preventDefault();

        this.props.logout(storage.authTokean);
    }

    render() {
        const { id, title, company, position } = this.props;

        return (
            <div className="btn-toolbar pull-right" style={{ margin: "7px 0 0 15px", fontSize: "14px" }}>
                <a className="btn dropdown-toggle" data-toggle="dropdown" href="#">
                    {title}  <span className="caret"></span>
                </a>
                <ul className="dropdown-menu">
                    <li><a href="#" onClick={this.logout.bind(this)}>Выйти</a></li>
                </ul>
            </div>
        );
    }   
}