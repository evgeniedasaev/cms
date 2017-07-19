import { Model } from 'redux-orm';

import { MODEL_ACTIONS } from '../api';

export default class schemaBase extends Model {
    static reducer(action, modelClass) {
        const { payload, type } = action;

        switch (type) {
            case MODEL_ACTIONS.CREATE_ACTION:
                const modelName = modelClass.toString().split('(' || /s+/)[0].split(' ' || /s+/)[1];

                if (modelName in payload) {
                    Object.values(payload[modelName]).forEach(denormalizedData => {
                        let props = {
                            id: denormalizedData.id,
                            ...denormalizedData.attributes
                        };

                        if ('relationships' in denormalizedData) {
                            for (let assosiation in denormalizedData.relationships) {
                                let assosiationValues = denormalizedData.relationships[assosiation];

                                if ('data' in assosiationValues) {
                                    let ids = [];

                                    if (Array.isArray(assosiationValues.data)) {
                                        ids = assosiationValues.data.map(entity => entity.id);
                                    } else if (assosiationValues.data !== null) {
                                        ids = assosiationValues.data.id;
                                    }

                                    props[assosiation] = ids;
                                }
                            }
                        }

                        if (modelClass.hasId(props.id)) {
                            const instanse = modelClass.withId(props.id);

                            instanse.update(props);
                        } else {
                            modelClass.create(props);
                        }
                    });
                }

                break;
        }
    }
}
