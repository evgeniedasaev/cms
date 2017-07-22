import React, { PureComponent, PropTypes } from 'react';
import {connect} from 'react-redux';
import Header from '../../components/Header/index';
import Sidebar from '../../components/Sidebar/index';
import Footer from '../../components/Footer/index';
import {
  PageLayout,
  MainLayout,
  MainContent,
  SidebarSemanticPusherStyled,
  SidebarSemanticPushableStyled,
  MainContainer,
  StyledDimmer
} from './style';

import {initApp, closeSidebar, openSidebar, windowResize} from '../../action';

/**
 * Основное приложение
 * 
 * @class AppIndex
 * @extends {PureComponent}
 */
class AppIndex extends PureComponent {
    
    componentWillMount () {
        const {initApp, handleWindowResize, isLoggedIn} = this.props;
    
        initApp();
        
        window.addEventListener('resize', handleWindowResize);
    }
    
    /**
     * render
     * 
     * @returns 
     * @memberof AppIndex
     */
    render() {
        const {
            children,
            sidebarOpened,
            closeSidebar,
            isLoggedIn,
            toggleSidebar,
            isMobile
        } = this.props;
        
        const   sidebarProps = {
                    open: sidebarOpened,
                    logout: () => console.log('logout'),
                    routing: [],
                    isMobile
                },
                headerProps = {
                    title: "DAC CMS 3.0",
                    toggleSidebar,
                    isMobile,
                    isLoggedIn
                },
                dimmerProps = {
                    active: true,
                    onClick: closeSidebar
                },
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
                                    {children}
                                </MainContainer>
                            </MainContent>
                            <Footer /> 
                        </MainLayout>
                    </SidebarSemanticPusherStyledPatch>
                    {isLoggedIn && sidebarOpened && <StyledDimmer {...dimmerProps} />} 
                </SidebarSemanticPushableStyled>
            </PageLayout>
        );
    };
}

function mapStateToProps (state) {
  const {sidebarOpened, isMobile, isMobileXS, isMobileSM, isLoggedIn} = state.app
  return {
    sidebarOpened,
    isMobile,
    isMobileXS,
    isMobileSM,
    isLoggedIn
  }
}

function mapDispatchToProps (dispatch) {
  let resizer
  return {
    initApp: () => {
        dispatch(initApp())
    },
    closeSidebar: () => {
        dispatch(closeSidebar())
    },
    toggleSidebar: () => {
        dispatch(openSidebar())
    },
    handleWindowResize: () => {
        clearTimeout(resizer)
        resizer = setTimeout(() => dispatch(windowResize()), 150)
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AppIndex);
