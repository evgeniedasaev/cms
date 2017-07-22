import { AUTH_LOGON, AUTH_LOGOUT } from '../action/constants';

const INITIAL_STATE = {
    loading: false,
    messages: [],

    isLoggedIn: typeof sessionStorage.authTokean !== 'undefined',

    userId: (typeof sessionStorage.userId !== 'undefined') ? sessionStorage.userId : null,
    userTitle: (typeof sessionStorage.userTitle !== 'undefined') ? sessionStorage.userTitle : null,
    userCompany: (typeof sessionStorage.userCompany !== 'undefined') ? sessionStorage.userCompany : null,
    userPosition: (typeof sessionStorage.userPosition !== 'undefined') ? sessionStorage.userPosition : null,
};

export default (state = INITIAL_STATE, action) => {
    const { type } = action;

    switch (type) {
        case AUTH_LOGON.request:
            return authentificate(state, action);

        case AUTH_LOGON.success:
            return authentificateSuccess(state, action);

        case AUTH_LOGON.failure:
            return authentificateFailure(state, action);

        case AUTH_LOGOUT.request:
            return deAuthentificate(state, action);

        case AUTH_LOGOUT.success:
            return deAuthentificateSuccess(state, action);

        case AUTH_LOGOUT.failure:
            return deAuthentificateFailure(state, action);

        default:
            return state;
    }
}

function authentificate(state, action) {
    return state;
}

function authentificateSuccess(state, action) {
    const { payload: { operations } } = action;

    Object.values(operations).map(operation => {
        const {data, errors} = operation;

        if (data) {
            const { id, attributes: { authTokean, userTitle, userCompany, userPosition } } = data;

            if (typeof authTokean !== 'undefined') {
                sessionStorage.setItem('authTokean', authTokean);
                sessionStorage.setItem('userId', id);
                sessionStorage.setItem('userTitle', userTitle);
                sessionStorage.setItem('userCompany', userCompany);
                sessionStorage.setItem('userPosition', userPosition);

                return { ...state, isLoggedIn: true, userId: id, userTitle, userCompany, userPosition };
            }
        }
    })

    return state;
}

function authentificateFailure(state, action) {
    const { payload: { operations } } = action;

    return state;
}

function deAuthentificate(state, action) {
    return state;
}

function deAuthentificateSuccess(state, action) {
    sessionStorage.removeItem('authTokean');
    sessionStorage.removeItem('userId');
    sessionStorage.removeItem('userTitle');
    sessionStorage.removeItem('userCompany');
    sessionStorage.removeItem('userPosition');

    return { ...state, isLoggedIn: false, userId: null, userTitle: null, userCompany: null, userPosition: null };
}

function deAuthentificateFailure(state, action) {
    return state;
}
