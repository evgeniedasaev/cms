import React, { PureComponent, PropTypes } from 'react';
import {connect} from 'react-redux';
import {Loader, Dimmer, Message} from 'semantic-ui-react';
import Header from '../../components/Header/index';
import Sidebar from '../../components/Sidebar/index';
import {
  PageLayout,
  MainLayout,
  MainContent,
  SidebarSemanticPusherStyled,
  SidebarSemanticPushableStyled,
  MainContainer,
  StyledDimmer
} from './style';
import {initApp, closeSidebar, openSidebar, windowResize, dismissMessage} from '../../action';
import {logout} from '../../../Login/action';

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
    
    handleMessageDismiss (messageIndex) {
        const {dismissMessage} = this.props;

        dismissMessage(messageIndex);
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
            userFullTitle,
            toggleSidebar,
            isMobile,
            loading,
            messages,
            authTokean,
            logout
        } = this.props;

        const   sidebarProps = {
                    open: sidebarOpened,
                    logout: logout.bind(this, authTokean),
                    routing: [],
                    isMobile
                },
                headerProps = {
                    title: "DAC CMS 3.0",
                    toggleSidebar,
                    isMobile,
                    isLoggedIn,
                    userFullTitle
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
                                    {messages && messages.map((message, i) => {
                                        return (
                                            <Message floating negative key={i} onDismiss={this.handleMessageDismiss.bind(this, i)}>
                                                <Message.Header>Произошла ошибка</Message.Header>
                                                <p>{message.msg}</p>
                                            </Message>
                                        );
                                    })}
                                    {!loading && children}
                                    {loading && <Dimmer active inverted>
                                        <Loader active>Загрузка...</Loader>
                                    </Dimmer>}
                                </MainContainer>
                            </MainContent>
                        </MainLayout>
                    </SidebarSemanticPusherStyledPatch>
                    {isLoggedIn && sidebarOpened && <StyledDimmer {...dimmerProps} />} 
                </SidebarSemanticPushableStyled>
            </PageLayout>
        );
    };
}

function mapStateToProps (state) {
  const {sidebarOpened, isMobile, isMobileXS, isMobileSM, loading, messages} = state.app;
  const {isLoggedIn, authTokean, userTitle, userCompany, userPosition} = state.auth;
  
  let userFullTitle = userTitle;
  if (userPosition) {
      userFullTitle += ", " + userPosition;
  }
  if (userCompany) {
      userFullTitle += "@" + userCompany;
  }

  return {
    sidebarOpened,
    isMobile,
    isMobileXS,
    isMobileSM,
    isLoggedIn,
    loading,
    messages,
    authTokean,
    userFullTitle
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
    },
    dismissMessage: (messageIndex) => {
        dispatch(dismissMessage(messageIndex));
    },
    logout: (authTokean) => {
        dispatch(logout(authTokean));
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AppIndex);
