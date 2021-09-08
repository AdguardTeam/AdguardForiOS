/* eslint-disable */
import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { translator } from '../../../../common/translators/translator';
import { Action } from '../Action';
import { Switcher } from '../../Switcher';
import { popupStore } from '../../../stores/PopupStore';
import { Button } from '../../Button';
import { Icon } from '../../ui/Icon';

export const ProtectionToggle = observer(() => {
    const store = useContext(popupStore);

    const { protectionEnabled } = store;

    const toggleProtection = () => {
        store.toggleProtection();
    };

    let description = translator.getMessage('popup_action_safari_protection_description');
    let descriptionColor = 'gray';

    let button;

    if (!store.contentBlockersEnabled) {
        description = translator.getMessage('popup_action_safari_protection_description_disabled');
        descriptionColor = 'yellow';

        const handleInfoTouch = () => {
            store.setShowContentBlockersEnabledModal(true);
        };

        button = (
            <Button onClick={handleInfoTouch} classNames="actions__control">
                <Icon color="yellow" iconId="info" />
            </Button>
        );
    } else {
        button = <div className="actions__control">
            <Switcher onChange={toggleProtection} enabled={protectionEnabled} />
        </div>
    }

    return (
        <label className="action-label">
            <Action
                iconId="compass"
                iconColor="green"
                title={translator.getMessage('popup_action_safari_protection_title')}
                titleMod="light"
                description={description}
                descriptionMod={descriptionColor}
            >
                {button}
            </Action>
        </label>
    );
});
