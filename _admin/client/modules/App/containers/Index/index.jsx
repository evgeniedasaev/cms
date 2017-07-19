import React, { PureComponent, PropTypes } from 'react';

import Header from '../../components/Header/index.jsx';
import Sidebar from '../../components/Sidebar/index.jsx';
import Footer from '../../components/Footer/index.jsx';
import {
  PageLayout,
  MainLayout,
  MainContent,
  SidebarSemanticPusherStyled,
  SidebarSemanticPushableStyled,
  MainContainer,
  StyledDimmer
} from './style.jsx';

/**
 * Основное приложение
 * 
 * @class AppIndex
 * @extends {PureComponent}
 */
export default class AppIndex extends PureComponent {
    
    /**
     * render
     * 
     * @returns 
     * @memberof AppIndex
     */
    render() {
        const   isLoggedIn = true,
                isMobile = false,
                sidebarOpened = true,
                sidebarProps = {
                    open: true,
                    logout: () => console.log('logout'),
                    routing: [],
                    isMobile
                },
                headerProps = {
                    title: "DAC CMS 3.0",
                    toggleSidebar: () => console.log('open sidebar'),
                    isMobile,
                    isLoggedIn
                },
                dimmerProps = {},
                SidebarSemanticPusherStyledPatch =
                    !isMobile && isLoggedIn
                        ? SidebarSemanticPusherStyled.extend`
                            max-width: calc(100% - 150px);
                        `
                        : SidebarSemanticPusherStyled;
                
        return (
            <PageLayout>
                <SidebarSemanticPushableStyled>
                    {isLoggedIn && <Sidebar {...sidebarProps} />} 
                    <SidebarSemanticPusherStyledPatch>
                        <Header {...headerProps} /> 
                        <MainLayout>
                            <MainContent>
                                <MainContainer id="main-container">
                                    {this.props.children}
                                </MainContainer>
                            </MainContent>
                            <Footer /> 
                        </MainLayout>
                    </SidebarSemanticPusherStyledPatch>
                    {/* {isLoggedIn && sidebarOpened && <StyledDimmer {...dimmerProps} />} */}
                </SidebarSemanticPushableStyled>
            </PageLayout>
        );
    };
}