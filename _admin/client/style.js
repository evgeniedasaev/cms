import {injectGlobal} from 'styled-components';
import 'semantic-ui-css/semantic.css';

injectGlobal`
  * {
    box-sizing: border-box;
  }

  #app {
    width: 100%;
    height: 100%;
  }
`
