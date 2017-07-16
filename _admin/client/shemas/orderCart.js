import { Model, many, fk, attr } from 'redux-orm';
import schemaBase from './schemaBase';


export default class OrderCart extends schemaBase {
    static get modelName() {
        return 'OrderCart';
    }
}