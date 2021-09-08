import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { Action } from '../Action';
import { Button } from '../../Button';
import { Icon } from '../../ui/Icon';
import { popupStore } from '../../../stores/PopupStore';

export const CurrentSite = observer(() => {
    const store = useContext(popupStore);

    let button;
    if (!store.premiumApp) {
        const handleInfoTouch = () => {
            store.showUpgradeModal();
        };

        button = (
            <Button onClick={handleInfoTouch} classNames="actions__control">
                <Icon color="yellow" iconId="info" />
            </Button>
        );
    }

    return (
        <Action
            iconId="network"
            iconColor="gray400"
            iconDataUrl={store.currentSiteFaviconDataUrl}
            title={store.currentSiteDomain}
            titleMod="bold"
            description={store.currentSiteStatusMessage}
            // TODO yellow if all blockers are disabled
            // descriptionMod="yellow"
        >
            {button}
        </Action>
    );
});
