import React, { PureComponent, PropTypes } from 'react';
import {connect} from 'react-redux';
import {Loader, Dimmer, Message} from 'semantic-ui-react';
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
import {initApp, closeSidebar, openSidebar, windowResize, dismissMessage} from '../../action';

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
            toggleSidebar,
            isMobile,
            loading,
            messages
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
  const {sidebarOpened, isMobile, isMobileXS, isMobileSM, loading, messages} = state.app;
  const {isLoggedIn} = state.auth;

  return {
    sidebarOpened,
    isMobile,
    isMobileXS,
    isMobileSM,
    isLoggedIn,
    loading,
    messages
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
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AppIndex);
