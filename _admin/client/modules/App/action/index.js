import { AUTH_METHODS, API_METHODS, callAction } from '../../../api';
import { APP_INFO } from './constants';

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