import { APP_INFO } from '../action/constants';

const INITIAL_STATE = {
    appInfoLoaded: false,
    loggedIn: typeof sessionStorage.authTokean !== 'undefined',

    title: null,
    logo: null,
    navigation: []
};

export default (state = INITIAL_STATE, action) => {
    const { type } = action;

    switch (type) {
        case APP_INFO.request:
            return fetchAppInfo(state, action);

        case APP_INFO.success:
            return fetchAppInfoSuccess(state, action);

        case APP_INFO.failure:
            return fetchAppInfoFailure(state, action);

        default:
            return state;
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