import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { Action } from '../Action';
import { Button } from '../../Button';
import { Icon } from '../../ui/Icon';
import { popupStore } from '../../../stores/PopupStore';
import { translator } from '../../../../common/translators/translator';

enum SiteStatus {
    ProtectionStarting = 'ProtectionStarting',
    ProtectionEnabled = 'ProtectionEnabled',
    ProtectionDisabled = 'ProtectionDisabled',
    Allowlisted = 'Allowlisted',
    BasicOnly = 'BasicOnly',
}

const SiteStatusesMessages = {
    [SiteStatus.ProtectionStarting]: translator.getMessage('popup_action_current_site_desc_starting'),
    [SiteStatus.ProtectionEnabled]: translator.getMessage('popup_action_current_site_status_desc_enabled'),
    [SiteStatus.ProtectionDisabled]: translator.getMessage('popup_action_current_site_status_desc_disabled'),
    [SiteStatus.Allowlisted]: translator.getMessage('popup_action_current_site_desc_allowlisted'),
    [SiteStatus.BasicOnly]: translator.getMessage('popup_action_current_site_desc_basic_only'),
};

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

    let description = SiteStatusesMessages[SiteStatus.ProtectionEnabled];
    let descriptionColor = 'gray';

    if (!store.protectionEnabled) {
        description = SiteStatusesMessages[SiteStatus.Allowlisted];
    }

    if (!store.contentBlockersEnabled) {
        description = SiteStatusesMessages[SiteStatus.ProtectionDisabled];
        descriptionColor = 'yellow';
        button = undefined;
    }

    return (
        <Action
            iconId="network"
            iconColor="gray400"
            iconDataUrl={store.currentSiteFaviconDataUrl}
            title={store.currentSiteDomain}
            titleMod="bold"
            description={description}
            descriptionMod={descriptionColor}
        >
            {button}
        </Action>
    );
});
