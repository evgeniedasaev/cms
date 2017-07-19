import React, { Component, PropTypes } from 'react';

export default class Header extends Component {

    render () {
        return (
            <header className="sticky-header">
                {   
                    this.props.showFilterToggler &&
                    <ul className="nav nav-pills pull-right">
                        <li>
                            <a href="#">
                                <i className="fa fa-filter"></i>
                            </a>
                        </li>
                    </ul>
                }
                <h1>{this.props.title}</h1>
                <div className="clear"></div>
            </header>        
        );
    }
}