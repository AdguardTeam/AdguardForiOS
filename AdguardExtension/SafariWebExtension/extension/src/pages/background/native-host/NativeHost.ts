/* eslint-disable class-methods-use-this */
import { browser } from 'webextension-polyfill-ts';

import { MessagesToNativeApp } from '../../common/constants';
import { nativeHostMock } from './nativeHostMock';

interface NativeHostMessage {
    type: MessagesToNativeApp,
    data?: unknown
}

export class NativeHost {
    APP_ID = 'application_id';

    private async sendNativeMessage(type: MessagesToNativeApp, data?: unknown) {
        const message: NativeHostMessage = { type };
        if (data) {
            message.data = data;
        }

        return browser.runtime.sendNativeMessage(this.APP_ID, message);
    }

    isProtectionEnabled(url: string): Promise<boolean> {
        // TODO remove
        return nativeHostMock.isProtectionEnabled(url);

        return this.sendNativeMessage(MessagesToNativeApp.IsProtectionEnabled, { url });
    }

    enableProtection(): Promise<void> {
        // TODO remove
        return nativeHostMock.enableProtection();

        return this.sendNativeMessage(MessagesToNativeApp.EnableProtection);
    }

    disableProtection(): Promise<void> {
        // TODO remove
        return nativeHostMock.disableProtection();

        return this.sendNativeMessage(MessagesToNativeApp.DisableProtection);
    }

    hasUserRulesBySite(url: string) {
        // TODO remove
        return nativeHostMock.hasUserRulesBySite(url);

        return this.sendNativeMessage(MessagesToNativeApp.HasUserRulesBySite, { url });
    }

    removeUserRulesBySite(url: string) {
        // TODO remove
        return nativeHostMock.removeUserRulesBySite(url);

        return this.sendNativeMessage(MessagesToNativeApp.RemoveUserRulesBySite, { url });
    }

    reportProblem(url?: string) {
        const type = MessagesToNativeApp.ReportProblem;

        if (url) {
            return this.sendNativeMessage(type, { url });
        }

        return this.sendNativeMessage(type);
    }

    isPremiumApp() {
        // TODO remove
        return nativeHostMock.isPremium();

        return this.sendNativeMessage(MessagesToNativeApp.IsPremium);
    }

    getAppearanceTheme() {
        // TODO remove
        return nativeHostMock.getAppearanceTheme();

        return this.sendNativeMessage(MessagesToNativeApp.GetAppearanceTheme);
    }

    areContentBlockersEnabled() {
        // TODO remove
        return nativeHostMock.areContentBlockersEnabled();

        return this.sendNativeMessage(MessagesToNativeApp.AreContentBlockersEnabled);
    }

    upgradeMe() {
        return this.sendNativeMessage(MessagesToNativeApp.UpgradeMe);
    }
}
