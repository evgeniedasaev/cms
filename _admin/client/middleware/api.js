import normalize from 'json-api-normalizer';
import * as uid from 'uid-safe';
import humps from 'humps';

export const MODEL_ACTIONS = {
    CREATE_ACTION: "CREATE_MODELS",
    DELETE_ACTION: "DELETE_MODELS"
}

export const AUTH_METHODS = {
    logon: "logon",
    logout: "logout"
}

export const API_METHODS = {
    createItem: "create_item",
    updateItem: "update_item",
    deleteItem: "delete_item",
    fetchItem: "fetch_item",
    fetchList: "fetch_list",
    featchRelationships: "fetch_relationships"
}

export const API_ACTIONS = {
    init: "API_INIT",
    request: "API_REQUEST",
    success: "API_SUCCESS",
    failure: "API_FAILURE"
};

export default (enpoint_host) => {
    const API_ENDPOINT_HOST = enpoint_host;

    const requestOptions = {
        method: "POST",
        headers: {
            'Content-Type': 'application/vnd.api+json',
            Accept: 'application/vnd.api+json'
        }
    };

    return (store) => (next) => (action) => {
        const { type, payload: requestObject, scope, endpointAction } = action;

        if (Object.values(API_ACTIONS).indexOf(type) < 0) {
            return next(action);
        }

        store.dispatch({
            type: scope + ((typeof endpointAction.request !== 'undefined') ? endpointAction.request : API_ACTIONS.request),
            payload: requestObject
        });

        return fetch(
            API_ENDPOINT_HOST,
            {
                ...requestOptions,
                body: JSON.stringify({
                    tokean: (sessionStorage.authTokean) ? sessionStorage.authTokean : '',
                    operations: requestObject
                })
            }
        )
            .then(function (res) { return res.json(); })
            .then(function (data) {
                if ('operations' in data) {
                    const modelsData = {};

                    Object.values(data.operations).map(operation => {
                        const normalizedData = normalize(operation, { camelizeKeys: false });

                        for (let modelName in normalizedData) {                           
                            if (modelName != "meta" && modelName in normalizedData) {
                                if (!modelsData[humps.pascalize(modelName)]) {
                                    modelsData[humps.pascalize(modelName)] = normalizedData[modelName];
                                } else {
                                    modelsData[humps.pascalize(modelName)] = {
                                        ...modelsData[humps.pascalize(modelName)],
                                        ...normalizedData[modelName]
                                    }
                                }
                            }
                        }
                    });

                    store.dispatch({
                        type: scope + ((typeof endpointAction.success !== 'undefined') ? endpointAction.success : API_ACTIONS.success),
                        payload: data
                    });

                    store.dispatch({
                        type: MODEL_ACTIONS.CREATE_ACTION,
                        payload: modelsData
                    });
                }
            })
            .catch(function (error) {
                store.dispatch({
                    type: scope + ((typeof endpointAction.failure !== 'undefined') ? endpointAction.failure : API_ACTIONS.failure),
                    payload: [error]
                });
            });
    }
}

export function callAction(batch = [], scope = "", endpointAction = {}) {
    return {
        type: API_ACTIONS.init,
        payload: batch.map(operation => {
            return {
                ...operation,
                uid: uid.sync(6)
            }
        }),
        scope,
        endpointAction
    }
}
