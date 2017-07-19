import { AUTH_METHODS, API_METHODS, callAction } from '../../../api';

export const AUTH_LOGON = {
    request: "AUTH_LOGON_REQUEST",
    success: "AUTH_LOGON_SUCCESS",
    failure: "AUTH_LOGON_FAILED"
};

export function logon({ login, passwd }) {
    return dispatch => {
        dispatch(callAction(
            [
                {
                    method: AUTH_METHODS.logon,
                    endpoint: 'auth',
                    params: { login, passwd }
                }
            ],
            '',
            AUTH_LOGON
        ));
    }
}

export const AUTH_LOGOUT = {
    request: "AUTH_LOGOUT_REQUEST",
    success: "AUTH_LOGOUT_SUCCESS",
    failure: "AUTH_LOGOUT_FAILED"
};

export function logout(tokean) {
    return dispatch => {
        dispatch(callAction(
            [
                {
                    method: AUTH_METHODS.logout,
                    endpoint: 'auth',
                    params: { tokean }
                }
            ],
            '',
            AUTH_LOGOUT
        ));
    }
}

export const APP_INFO = {
    request: "APP_INFO_REQUEST",
    success: "APP_INFO_SUCCESS",
    failure: "APP_INFO_FAILED"
};

export function fetchAppInfo(userId) {
    return dispatch => {
        dispatch(callAction(
            [
                {
                    method: API_METHODS.fetchList,
                    endpoint: 'application',
                    params: { user_id: userId }
                }
            ],
            '',
            APP_INFO
        ));
    }
}
