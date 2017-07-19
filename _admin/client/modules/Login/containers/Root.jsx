import React, { PureComponent, PropTypes } from 'react';
import {
  PageLayout,
  MainLayout,
  MainContent,
  SidebarSemanticPusherStyled,
  SidebarSemanticPushableStyled,
  MainContainer,
  StyledDimmer
} from '../style/index.jsx';

export default class Root extends PureComponent {

    render() {
        const isLoggedIn = false;
        
        return (
            <PageLayout>
                <SidebarSemanticPushableStyled>
                {isLoggedIn && <Sidebar {...sidebarProps} />}
       
                    <Header {...headerProps} />
                    <MainLayout>
                    <MainContent>
                        <MainContainer id="main-container">
                        {this.props.children}
                        </MainContainer>
                    </MainContent>
                    <Footer />
                    </MainLayout>
                {/* NOTE:  show dimmer only if:
                                //1. isLoggedIn, elsewhere sidebar isn't visible
                            // 2. if sidebar is opened  */}
                {isLoggedIn && sidebarOpened && <StyledDimmer {...dimmerProps} />}
                </SidebarSemanticPushableStyled>
            </PageLayout>
        );
    }
}