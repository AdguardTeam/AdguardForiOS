import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { translator } from '../../../../common/translators/translator';
import { popupStore } from '../../../stores/PopupStore';
import { Button } from '../../Button';
import { Modal } from '../Modal';

export const UpgradeModal = observer(() => {
    const store = useContext(popupStore);

    const handleClose = () => {
        store.closeUpgradeModal();
    };

    const handleClick = () => {
        // TODO handle upgrade click button
    };

    return (
        <Modal
            title={translator.getMessage('popup_modal_title_free')}
            description={translator.getMessage('popup_modal_desc_free')}
            close={handleClose}
        >
            <Button
                onClick={handleClick}
                classNames="button--green button--l button--bottom"
            >
                {translator.getMessage('popup_modal_btn_free')}
            </Button>
        </Modal>
    );
});
