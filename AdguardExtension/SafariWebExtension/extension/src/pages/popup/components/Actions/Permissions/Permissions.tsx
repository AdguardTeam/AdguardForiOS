import React, { useContext } from 'react';
import { observer } from 'mobx-react';
import browser from 'webextension-polyfill';

import { Action } from '../Action';
import { popupStore } from '../../../stores/PopupStore';
import { WEB_EXTENSION_MORE_URL } from '../../../../common/constants';
import { translator } from '../../../../common/translators/translator';
import { Icon } from '../../ui/Icon';
import { Button } from '../../Button';

export const Permissions = observer(() => {
    const store = useContext(popupStore);

    const handleClick = async () => {
        await browser.tabs.create({ url: WEB_EXTENSION_MORE_URL });
    };

    if (store.allSitesAllowed) {
        return null;
    }

    return (
        <Action
            iconId="info"
            iconColor="yellow"
            onClick={handleClick}
            title={translator.getMessage('popup_action_insufficient_permissions')}
        >
            <Button onClick={() => {}} classNames="actions__control">
                <Icon color="gray400" iconId="faq" />
            </Button>
        </Action>
    );
});
