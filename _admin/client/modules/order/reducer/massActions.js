import { ORDER_MASS_ACTION } from '../action';

import ModalForAssignManager from '../components/ModalForAssignManager';
import ModalForChangeStatus from '../components/ModalForChangeStatus';

export const SCOPE = 'massAction_';

const INITIAL_STATE = {
    ids: [],
    currentAction: null,
    actions: [
        {
            code: 'CHANGE_STATUS',
            name: 'Сменить статус заказов',
            widget: ModalForChangeStatus,
        },
        {
            code: 'ASSIGN_MANAGER',
            name: 'Назначить менеджеров',
            widget: ModalForAssignManager,
        }
    ]
}

export default function massActionReducerFactory(rootScope = "") {
    const scope = rootScope + SCOPE;

    return (state = INITIAL_STATE, action) => {
        const { type } = action;

        switch (type) {
            case scope + ORDER_MASS_ACTION.selectOrder:
                return selectOrder(state, action);

            case scope + ORDER_MASS_ACTION.selectAction:
                return selectAction(state, action);

            case scope + ORDER_MASS_ACTION.clear:
                return clear(state, action);

            default:
                return state;
        }
    }
}

function selectOrder(state, action) {
    const { payload: { id } } = action;
    const { ids } = state;

    ids.push(id);

    return { ...state, ids };
}

function selectAction(state, action) {
    const { payload: { action: currentAction } } = action;

    return { ...state, currentAction };
}

function clear(state, action) {
    return {
        ...state,
        ids: [],
        currentAction: null,
    };
}
