import { Model, many, fk, attr } from 'redux-orm';
import schemaBase from './schemaBase';


export default class PaymentStatus extends schemaBase {
    static get modelName() {
        return 'PaymentStatus';
    }
}