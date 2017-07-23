import React, {PureComponent, PropTypes} from 'react';
import {Icon, Popup} from 'semantic-ui-react';
// import {isEqual} from 'lodash'
import {
  StyledHeader,
  HeaderInner,
  Navicon,
  PageTitle,
  HeaderButton
} from './style';
import {Spacer} from '../../styles/base';

export default class Header extends PureComponent {
/*   shouldComponentUpdate (nextProps) {
    return !isEqual(nextProps, this.props)
  } */

  static propTypes = {
    title: PropTypes.string,
    toggleSidebar: PropTypes.func,
    isLoggedIn: PropTypes.bool,
    isMobile: PropTypes.bool
  }

  render () {
    const {title, toggleSidebar, isLoggedIn, userFullTitle, isMobile} = this.props

    return (
      <StyledHeader>
        <HeaderInner>
          {isLoggedIn &&
            isMobile &&
            <Navicon onClick={toggleSidebar}>
              <Icon name="content" />
            </Navicon>}
          <PageTitle>
            {title}
          </PageTitle>
          <Spacer />
          {isLoggedIn && <Popup
            trigger={
              <HeaderButton
                id="header-button"
                icon
                as={'a'}
                aria-label="github-header-link-button"
                basic
                circular
              >
                <Icon name="user circle outline" size="large" link fitted/>
              </HeaderButton>
            }
            content={userFullTitle}
            inverted
          />}
        </HeaderInner>
      </StyledHeader>
    )
  }
}
