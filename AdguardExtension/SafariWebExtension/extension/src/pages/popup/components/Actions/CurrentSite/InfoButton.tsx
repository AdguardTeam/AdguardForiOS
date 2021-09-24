import { observer } from 'mobx-react';
import React, { useContext } from 'react';

import { popupStore } from '../../../stores/PopupStore';
import { Button } from '../../Button';
import { Icon } from '../../ui/Icon';

export const InfoButton = observer(() => {
    const store = useContext(popupStore);

    const showAttentionButton = !store.premiumApp || !store.advancedBlockingEnabled;

    let button = null;
    if (showAttentionButton) {
        let handler;
        if (!store.advancedBlockingEnabled) {
            handler = () => {
                store.showAdvancedBlockingDisabledModal();
            };
        }

        if (!store.premiumApp) {
            handler = () => {
                store.showUpgradeModal();
            };
        }

        if (handler) {
            button = (
                <Button onClick={handler} classNames="actions__control">
                    <Icon color="yellow" iconId="info" />
                </Button>
            );
        }
    }

    if (!store.contentBlockersEnabled) {
        button = null;
    }

    return button;
});
