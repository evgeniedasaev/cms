import React, { PureComponent, PropTypes } from 'react';

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
class AppIndex extends PureComponent {
    render() {
        const   isLoggedIn = true,
                sidebarOpened = true,
                sidebarProps = {},
                headerProps = {},
                dimmerProps = {};

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