import React, { PureComponent, PropTypes } from 'react';
import { Link } from 'react-router';

export default class Navigation extends PureComponent {

    render() {
        const { currentPathname, navigation } = this.props;
        const navigations = [], navigationTabs = [];

        navigation.map((navItem, navIndex) => {
            let link = null;
            let isActive = false;

            if ('link' in navItem) {
                link = this.generateLink(navItem.link);
                isActive = currentPathname == link;
            }

            if ('items' in navItem) {
                const subNavigations = [];

                navItem.items.map(($navItem, $navIndex) => {
                    if ($navItem.type == "header") {
                        subNavigations.push(
                            <li key={$navIndex} className="nav-header">{$navItem.name}</li>
                        );

                        if ('items' in $navItem) {
                            $navItem.items.map(($$navItem, $$navIndex) => {
                                const link = this.generateLink($$navItem.link);
                                const $$isActive = currentPathname == link;

                                if ($$isActive) {
                                    isActive = true;
                                }

                                subNavigations.push(
                                    this.renderSubItem($$navItem, navItem.code + '@' + $navItem.code + '@' + $$navIndex, $$navItem.code, link, $$isActive)
                                );
                            });
                        }
                    } else {
                        const link = this.generateLink($navItem.link);
                        const $isActive = currentPathname == link;

                        if ($isActive) {
                            isActive = true;
                        }

                        subNavigations.push(
                            this.renderSubItem($navItem, navItem.code + '@' + $navIndex, $navItem.code, link, $isActive)
                        );
                    }
                });

                navigationTabs.push(
                    <div key={'tab-' + navIndex} className="tab-pane secondmenu" id={"nav-" + navItem.code + "-menu"}>
                        <ul className="nav nav-tabs nav-stacked">{subNavigations}</ul>
                    </div>
                );
            }

            navigations.push(
                this.renderItem(navItem, navIndex, navItem.code, link, isActive)
            );
        });

        return (
            <div>
                <div className="topmenu">
                    <ul className="nav">
                        {navigations}
                    </ul>
                </div>
                <div className="tab-content">
                    {navigationTabs}
                </div>
            </div>
        );
    }

    renderItem(navigationItem, index, code, link, isActive) {
        const { name, icon } = navigationItem;
        
        const className = navigationItem.class + (isActive ? ' active' : '');
        
        const ancorIcon = typeof icon !== 'undefined' ? (
            <i className={icon}></i>
        ) : '';
        const ancorName = (
            <div>{name}</div>
        );

        return (
            <li key={index} className={className} id={'nav-' + code}>
                {('link' in navigationItem) &&
                    <Link
                        to={link}
                        title={name}
                    >
                        {ancorIcon}
                        {ancorName}
                    </Link>
                }
                {!('link' in navigationItem) &&
                    <a
                        href={'#nav-' + code + '-menu'}
                        title={name}
                        data-toggle='tab'
                    >
                        {ancorIcon}
                        {ancorName}
                    </a>
                }
            </li>
        );
    }
    
    renderSubItem(navigationItem, index, code, link, isActive) {
        const className = 
            (('class' in navigationItem) ? navigationItem.class : '') +
            (('bLink' in navigationItem) ? ' link' : '') +
            (isActive ? ' active' : '');
        
        return (
            <li 
                key={index}
                id={"nav-item-" + code}
                className={className}
            >
                <Link
                    to={link}
                    title={navigationItem.name}
                >
                    {navigationItem.name}
                </Link>
            </li>
        );
    }

    generateLink(linkObject) {
        let itemLink = '';

        if (typeof linkObject !== 'undefined') {
            itemLink = '/_admin/';
        }

        if ('controller' in linkObject) {
            itemLink += linkObject.controller;
        }

        if ('action' in linkObject) {
            itemLink += linkObject.action;
        }

        itemLink += '/';

        return itemLink;
    }
}