import React, { PureComponent, PropTypes } from 'react';
import Select from 'react-select';

export default class MassAction extends PureComponent {

    render() {
        const { ids, action, actionList, onSelectAction } = this.props;

        return (
            <div className="row-fluid" style={{
                position: 'fixed',
                top: '110px',
                width: '100%',
                padding: '10px 15px',
                backgroundColor: 'white',
                boxShadow: '0 0 0 1px rgba(0, 0, 0, 0.1), 0 6px 6px -4px rgba(0, 0, 0, 0.14)',
                background: '#FFF',
                zIndex: '100000000'
            }}>
                <div className="span5">
                    <Select
                        placeholder="Выберите действие"
                        value={action}
                        options={actionList.map((actionItem) => {
                            return { value: actionItem.code, label: actionItem.name };
                        })}
                        onChange={onSelectAction} />
                </div>
                <div className="span7" style={{
                    padding: '8px 0',
                    fontWeight: 'bold'
                }}>
                    Выбрано: {ids.length}
                </div>
            </div>
        );
    }
}