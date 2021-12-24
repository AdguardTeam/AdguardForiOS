import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { reactTranslator } from '../../../../common/translators/reactTranslator';
import { Icon } from '../../ui/Icon';
import { boldText } from '../../ui/formatting';
import { Modal } from '../Modal';
import { translator } from '../../../../common/translators/translator';
import { popupStore } from '../../../stores/PopupStore';

import './protection-modal.pcss';

export const ProtectionModal = observer(() => {
    const store = useContext(popupStore);

    const handleClose = () => {
        store.setProtectionModalVisibleState(false);
    };

    return (
        <Modal
            title={translator.getMessage('modal_protection_off_title')}
            close={handleClose}
        >
            <div className="protection-off">
                <div className="protection-off__item">
                    <Icon iconId="settings" />
                    <div className="protection-off__info">
                        {reactTranslator.getMessage('modal_protection_off_settings', { b: boldText })}
                    </div>
                </div>
                <div className="protection-off__item">
                    <Icon iconId="safari" />
                    <div className="protection-off__info">
                        {reactTranslator.getMessage('modal_protection_off_extensions', { b: boldText })}
                    </div>
                </div>
                <div className="protection-off__item">
                    <Icon iconId="switcher" />
                    <div className="protection-off__info">
                        {reactTranslator.getMessage('modal_protection_off_switch', { b: boldText })}
                    </div>
                </div>
            </div>
        </Modal>
    );
});
