import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { Action } from '../Action';
import { InfoButton } from './InfoButton';
import { popupStore } from '../../../stores/PopupStore';
import { translator } from '../../../../common/translators/translator';
import { SiteStatus } from '../../../constants';

const SiteStatusesMessages = {
    [SiteStatus.ProtectionStarting]: translator.getMessage('popup_action_current_site_desc_starting'),
    [SiteStatus.ProtectionEnabled]: translator.getMessage('popup_action_current_site_status_desc_enabled'),
    [SiteStatus.ProtectionDisabled]: translator.getMessage('popup_action_current_site_status_desc_disabled'),
    [SiteStatus.Allowlisted]: translator.getMessage('popup_action_current_site_desc_allowlisted'),
    [SiteStatus.BasicOnly]: translator.getMessage('popup_action_current_site_desc_basic_only'),
};

export const CurrentSite = observer(() => {
    const store = useContext(popupStore);

    let description = SiteStatusesMessages[SiteStatus.ProtectionEnabled];
    let descriptionColor = 'gray';

    if (!store.premiumApp || !store.advancedBlockingEnabled) {
        description = SiteStatusesMessages[SiteStatus.BasicOnly];
    }

    if (!store.protectionEnabled) {
        description = SiteStatusesMessages[SiteStatus.Allowlisted];
    }

    if (!store.contentBlockersEnabled) {
        description = SiteStatusesMessages[SiteStatus.ProtectionDisabled];
        descriptionColor = 'yellow';
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
            <InfoButton />
        </Action>
    );
});
