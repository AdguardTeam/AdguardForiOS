import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { translator } from '../../../../common/translators/translator';
import { popupStore } from '../../../stores/PopupStore';
import { Button } from '../../Button';
import { Modal } from '../Modal';
import { messenger } from '../../../../common/messenger';

export const UpgradeModal = observer(() => {
    const store = useContext(popupStore);

    const handleClose = () => {
        store.closeUpgradeModal();
    };

    const handleClick = async () => {
        await messenger.handleUpgrade();
        window.close();
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
