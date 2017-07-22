import { AUTH_METHODS, API_METHODS, callAction } from '../../../api';
import { AUTH_LOGON, AUTH_LOGOUT } from './constants';

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
