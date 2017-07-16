import { Model, many, fk, attr } from 'redux-orm';
import schemaBase from './schemaBase';


export default class Brand extends schemaBase {
    static get modelName() {
        return 'Brand';
    }
}