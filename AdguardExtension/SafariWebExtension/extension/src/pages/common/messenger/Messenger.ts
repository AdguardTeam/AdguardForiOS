import browser from 'webextension-polyfill';

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

        const VERBOSE = true;

        log.debug(VERBOSE, 'Request message:', message);

        const response = await browser.runtime.sendMessage(message);

        if (response) {
            log.debug(VERBOSE, 'On message:', message);
            log.debug(VERBOSE, 'Received response:', response);
        }

        return response;
    }

    getPopupData = (url?: string) => {
        return this.sendMessage(MessagesToBackgroundPage.GetPopupData, { url });
    };

    setPermissionsModalViewed = () => {
        return this.sendMessage(MessagesToBackgroundPage.SetPermissionsModalViewed);
    };

    setProtectionStatus = (protectionStatus: boolean, url: string) => {
        return this.sendMessage(
            MessagesToBackgroundPage.SetProtectionStatus,
            { enabled: protectionStatus, url },
        );
    };

    enableSafariProtection = (url: string) => {
        return this.sendMessage(
            MessagesToBackgroundPage.EnableSafariProtection,
            { url },
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

    enableAdvancedBlocking = () => {
        return this.sendMessage(
            MessagesToBackgroundPage.EnableAdvancedBlocking,
        );
    };
}
