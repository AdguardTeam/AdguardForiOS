import browser from 'webextension-polyfill';

import { MessagesToNativeApp } from './constants';

export const logNative = (message: string) => {
    if (!browser.runtime.sendNativeMessage) {
        console.log(message);
    } else {
        browser.runtime.sendNativeMessage(
            'application-id',
            {
                type: MessagesToNativeApp.WriteInNativeLog,
                data: message,
            },
        );
    }
};
