import { browser } from 'webextension-polyfill-ts';

import { MessagesToBackgroundPage } from '../constants';
import { log } from '../log';

interface Message {
    type: MessagesToBackgroundPage,
    data?: unknown
}

export class Messenger {
    // eslint-disable-next-line class-methods-use-this
    async sendMessage(type: MessagesToBackgroundPage, data?: unknown) {
        const message: Message = { type };

        if (data) {
            message.data = data;
        }

        log.debug('Request message:', message);

        const response = await browser.runtime.sendMessage(message);

        if (response) {
            log.debug('On message:', message);
            log.debug('Received response:', response);
        }

        return response;
    }

    getPopupData = (url?: string) => {
        return this.sendMessage(MessagesToBackgroundPage.GetPopupData, { url });
    };

    setPermissionsModalViewed = () => {
        return this.sendMessage(MessagesToBackgroundPage.SetPermissionsModalViewed);
    };

    setProtectionStatus = (protectionStatus: boolean) => {
        return this.sendMessage(
            MessagesToBackgroundPage.SetProtectionStatus,
            { enabled: protectionStatus },
        );
    };

    deleteUserRules = (url: string) => {
        return this.sendMessage(
            MessagesToBackgroundPage.DeleteUserRulesByUrl,
            { url },
        );
    };

    reportProblem = (url?: string) => {
        return this.sendMessage(
            MessagesToBackgroundPage.ReportProblem,
            { url },
        );
    };

    handleUpgrade = () => {
        return this.sendMessage(
            MessagesToBackgroundPage.UpgradeClicked,
        );
    };
}
