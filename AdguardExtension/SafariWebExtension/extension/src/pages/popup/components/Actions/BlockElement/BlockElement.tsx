import React from 'react';
import { browser } from 'webextension-polyfill-ts';

import { Action } from '../Action';
import { translator } from '../../../../common/translators/translator';
import { MessagesToBackgroundPage } from '../../../../common/constants';

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

export const BlockElement = () => {
    return (
        <Action
            iconId="aim"
            iconColor="red"
            title={translator.getMessage('popup_action_block_element')}
            onClick={handleBlock}
            // TODO if protection disabled
        />
    );
};
