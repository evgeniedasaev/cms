import React, { PureComponent, PropTypes } from 'react';
import Select from 'react-select';

export default class ModalForChangeStatus extends PureComponent {

    constructor() {
        super();

        this.state = {
            selectedId: 0
        }
    }

    onChange(evt) {
        this.setState({ selectedId: evt.value });
    }

    render() {
        const { list, onSubmit } = this.props;

        return (
            <form className="row-fluid" onSubmit={(evt) => {
                evt.preventDefault();

                this.props.onSubmit(this.state.selectedId);
            }}>
                <div className="span10">
                    <Select
                        placeholder="Выберите статус"
                        value={this.state.selectedId}
                        options={list.map(status => {
                            return { value: status.id, label: status.name };
                        })}
                        onChange={this.onChange.bind(this)} />
                </div>
                <div className="span2">
                    <button type="submit" className="btn">Сменить</button>
                </div>
            </form>
        );
    };
};
