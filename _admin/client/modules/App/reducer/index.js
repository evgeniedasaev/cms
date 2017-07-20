import { APP, UI } from '../action/constants';

const INITIAL_STATE = {
    isLoggedIn: typeof sessionStorage.authTokean !== 'undefined',
    sidebarOpened: false,

    isMobile: false,
    isMobileXS: false,
    isMobileSM: false,

    appInfoLoaded: false,
    title: null,
    logo: null,
    navigation: []
};

const computeMobileStatuses = () => {
    const {innerWidth} = window
    const isMobile = innerWidth < 1025 // 1024px - is the main breakpoint in ui
    const isMobileXS = innerWidth < 481
    const isMobileSM = innerWidth > 480 && innerWidth < 767
    return {isMobileSM, isMobileXS, isMobile}
}

export default (state = INITIAL_STATE, action) => {
    const { type } = action;

    switch (type) {
        case APP.init:
            return initApp(state, action);

        case UI.windowResize:
            return windowResize(state, action);

        case UI.openSidebar:
            return openSidebar(state, action);

        case UI.closeSidebar:
            return closeSidebar(state, action);

        case APP.request:
            return fetchAppInfo(state, action);

        case APP.success:
            return fetchAppInfoSuccess(state, action);

        case APP.failure:
            return fetchAppInfoFailure(state, action);

        default:
            return state;
    }
}

function initApp(state, action) {
    const {isMobile, isMobileSM, isMobileXS} = computeMobileStatuses()
    return {
        ...state,
        isMobile,
        isMobileSM,
        isMobileXS
    }
}

function windowResize(state, action) {
    const {isMobile, isMobileSM, isMobileXS} = computeMobileStatuses()
    return {
        ...state,
        isMobile,
        isMobileSM,
        isMobileXS
    }
}

function openSidebar(state, action) {
    return {
        ...state,
        sidebarOpened: true
    }
}

function closeSidebar(state, action) {
    return {
        ...state,
        sidebarOpened: false
    }
}

function fetchAppInfo(state, action) {
    return state;
}

function fetchAppInfoSuccess(state, action) {
    const { payload: { operations } } = action;
    const { data: { title, logo, navigation } } = Object.values(operations)[0];

    return {
        ...state,
        appInfoLoaded: true,
        title,
        logo,
        navigation
    };
}

function fetchAppInfoFailure(state, action) {
    return state;
}