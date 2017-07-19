import * as operators from './operators';

export const operatorsFilters = {
    [operators.CONTAINS]: (object, field, value) => {
        return object[field].match(new RegExp(value, 'g'));
    },

    [operators.BETWEEN]: (object, field, value) => {
        let dtCheck = Date.parse(object[field]);
        let dtFrom = Date.parse(value[0]);
        let dtTo = Date.parse(value[1]);

        // если dtCheck не определена
        if (isNaN(dtCheck)) return false;

        // ищем меньше dtFrom
        if (isNaN(dtFrom)) {
            return dtCheck <= dtFrom;
        }

        // ищем больше dtTo
        if (isNaN(dtTo)) {
            return dtCheck <= dtFrom && dtCheck >= dtTo;
        }

        return dtCheck >= dtTo;
    },

    [operators.EQUALS]: (object, field, value) => {
        return object[field] == value[0];
    },
};

