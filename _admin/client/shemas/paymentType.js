import { Model, many, fk, attr } from 'redux-orm';
import schemaBase from './schemaBase';


export default class PaymentType extends schemaBase {
    static get modelName() {
        return 'PaymentType';
    }
}