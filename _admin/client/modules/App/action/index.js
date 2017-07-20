import { AUTH_METHODS, API_METHODS, callAction } from '../../../api';
import { APP, UI } from './constants';

export function initApp() {
    return {
        type: APP.init
    }
}

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
            APP
        ));
    }
}

export function closeSidebar() {
    return {
        type: UI.closeSidebar
    }
}

export function openSidebar() {
    return {
        type: UI.openSidebar
    }
}

export function windowResize() {
    return {
        type: UI.windowResize
    }
}
