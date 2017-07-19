import React, { PureComponent, PropTypes } from 'react';
import { Modal as DynamicModal, ModalManager, Effect } from 'react-dynamic-modal';

export default class Modal extends PureComponent {

    render() {
        const { onClose, header , children } = this.props;

        return (
            <DynamicModal
                onRequestClose={() => {
                    onClose();

                    return true;
                }}
                effect={Effect.ScaleUp}
                style={{
                    overlay: {
                        zIndex: '100000000'
                    }
                }}
            >
                <div className="modal-header">
                    <h4 className="modal-title">{header}</h4>
                </div>
                <div className="modal-body" style={{minHeight: '250px'}}>{children}</div>
                <div className="modal-footer">
                    <button type="button" className="btn btn-default" onClick={(evt) => {
                        evt.preventDefault();
                        
                        ModalManager.close();
                    }}>
                        Закрыть
                    </button>
                </div>
            </DynamicModal>
        );
    }
}