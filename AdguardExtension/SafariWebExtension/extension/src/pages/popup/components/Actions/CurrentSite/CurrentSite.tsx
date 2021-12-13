import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { Action } from '../Action';
import { popupStore } from '../../../stores/PopupStore';
import { translator } from '../../../../common/translators/translator';
import { SiteStatus } from '../../../constants';
import { Button } from '../../Button';
import { Icon } from '../../ui/Icon';

const SiteStatusesMessages = {
    [SiteStatus.ProtectionStarting]: translator.getMessage('popup_action_current_site_desc_starting'),
    [SiteStatus.ProtectionEnabled]: translator.getMessage('popup_action_current_site_status_desc_enabled'),
    [SiteStatus.ProtectionDisabled]: translator.getMessage('popup_action_current_site_status_desc_disabled'),
    [SiteStatus.Allowlisted]: translator.getMessage('popup_action_current_site_desc_allowlisted'),
    [SiteStatus.AllowlistedInverted]: translator.getMessage('popup_action_current_site_desc_allowlisted_inverted'),
    [SiteStatus.BasicOnly]: translator.getMessage('popup_action_current_site_desc_basic_only'),
};

export const CurrentSite = observer(() => {
    const store = useContext(popupStore);

    let description = SiteStatusesMessages[SiteStatus.ProtectionEnabled];
    let descriptionColor = 'gray';
    let iconEnabled = true;

    if (!store.premiumApp || !store.advancedBlockingEnabled) {
        description = SiteStatusesMessages[SiteStatus.BasicOnly];
    }

    if (!store.protectionEnabled) {
        description = SiteStatusesMessages[SiteStatus.Allowlisted];
        descriptionColor = 'green';
        iconEnabled = false;
    }

    if (store.allowlistInverted) {
        if (store.protectionEnabled) {
            description = SiteStatusesMessages[SiteStatus.AllowlistedInverted];
            descriptionColor = 'green';
            iconEnabled = true;
        } else {
            description = SiteStatusesMessages[SiteStatus.ProtectionDisabled];
            descriptionColor = 'gray';
            iconEnabled = false;
        }
    }

    if (!store.contentBlockersEnabled) {
        description = SiteStatusesMessages[SiteStatus.ProtectionDisabled];
        descriptionColor = 'yellow';
        iconEnabled = false;
    }

    const determineHandlerAndIcon = () => {
        const showAttentionButton = !store.premiumApp || !store.advancedBlockingEnabled;

        const noopHandler = () => {};
        let button;
        let handler;
        if (showAttentionButton) {
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
            button = undefined;
            handler = noopHandler;
        }

        return {
            button,
            handler: handler || noopHandler,
        };
    };

    return (
        <Action
            iconId="network"
            iconColor="gray400"
            iconDataUrl={store.currentSiteFaviconDataUrl}
            title={store.currentSiteDomain}
            titleMod="bold"
            description={description}
            descriptionMod={descriptionColor}
            onClick={determineHandlerAndIcon().handler}
            iconEnabled={iconEnabled}
        >
            {determineHandlerAndIcon().button}
        </Action>
    );
});
