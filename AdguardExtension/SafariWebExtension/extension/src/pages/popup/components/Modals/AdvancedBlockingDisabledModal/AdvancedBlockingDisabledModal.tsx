import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { translator } from '../../../../common/translators/translator';
import { popupStore } from '../../../stores/PopupStore';
import { Button } from '../../Button';
import { Modal } from '../Modal';
import { messenger } from '../../../../common/messenger';

export const AdvancedBlockingDisabledModal = observer(() => {
    const store = useContext(popupStore);

    const handleClose = () => {
        store.hideAdvancedBlockingDisabledModal();
    };

    const handleClick = async () => {
        await messenger.enableAdvancedBlocking();
        window.close();
    };

    return (
        <Modal
            title={translator.getMessage('popup_modal_advanced_blocking_disabled_title')}
            description={translator.getMessage('popup_modal_advanced_blocking_disabled_description')}
            close={handleClose}
        >
            <Button
                onClick={handleClick}
                classNames="button--green button--l button--bottom"
            >
                {translator.getMessage('popup_modal_advanced_blocking_disabled_button')}
            </Button>
        </Modal>
    );
});
