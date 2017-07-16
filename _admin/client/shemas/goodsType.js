import { Model, many, fk, attr } from 'redux-orm';
import schemaBase from './schemaBase';


export default class GoodsType extends schemaBase {
    static get modelName() {
        return 'GoodsType';
    }
}