import React, { useContext } from 'react';
import { browser } from 'webextension-polyfill-ts';
import { observer } from 'mobx-react';

import { Action } from '../Action';
import { translator } from '../../../../common/translators/translator';
import { MessagesToBackgroundPage } from '../../../../common/constants';
import { popupStore } from '../../../stores/PopupStore';

const handleBlock = async () => {
    const [currentTab] = await browser.tabs.query({
        active: true,
        currentWindow: true,
    });

    await browser.runtime.sendMessage({
        type: MessagesToBackgroundPage.OpenAssistant,
        data: { tabId: currentTab.id },
    });

    window.close();
};

export const BlockElement = observer(() => {
    const store = useContext(popupStore);

    if (!store.protectionEnabled) {
        return null;
    }

    return (
        <Action
            iconId="aim"
            iconColor="red"
            title={translator.getMessage('popup_action_block_element')}
            onClick={handleBlock}
        />
    );
});
