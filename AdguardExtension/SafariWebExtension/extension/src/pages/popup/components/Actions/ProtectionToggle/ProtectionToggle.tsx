import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { translator } from '../../../../common/translators/translator';
import { Action } from '../Action';
import { Switcher } from '../../Switcher';
import { popupStore } from '../../../stores/PopupStore';

export const ProtectionToggle = observer(() => {
    const store = useContext(popupStore);

    const { protectionEnabled } = store;

    const toggleProtection = () => {
        store.toggleProtection();
    };

    return (
        <label>
            <Action
                iconId="compass"
                iconColor="green"
                title={translator.getMessage('popup_action_safari_protection_title')}
                titleMod="light"
                description={translator.getMessage('popup_action_safari_protection_description')}
                // TODO yellow if all blockers are disabled
                descriptionMod="gray"
            >
                <div className="actions__control">
                    <Switcher onChange={toggleProtection} enabled={protectionEnabled} />
                </div>
            </Action>
        </label>
    );
});
