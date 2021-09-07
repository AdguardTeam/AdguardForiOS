/* eslint-disable class-methods-use-this */
import { browser } from 'webextension-polyfill-ts';

import { MessagesToNativeApp } from '../../common/constants';
import { nativeHostMock } from './nativeHostMock';
import { getDomain } from '../../common/utils/url';

interface NativeHostMessage {
    type: MessagesToNativeApp,
    data?: unknown
}

export class NativeHost {
    APP_ID = 'application_id';

    links = {};

    private async sendNativeMessage(type: MessagesToNativeApp, data?: unknown) {
        const message: NativeHostMessage = { type };
        if (data) {
            message.data = data;
        }

        return browser.runtime.sendNativeMessage(this.APP_ID, message);
    }

    // @ts-ignore
    setLinks(links) {
        this.links = links;
    }

    addToUserRules(ruleText: string) {
        return this.sendNativeMessage(MessagesToNativeApp.AddToUserRules, { ruleText });
    }

    isProtectionEnabled(url: string): Promise<boolean> {
        // TODO remove
        return nativeHostMock.isProtectionEnabled(url);

        return this.sendNativeMessage(MessagesToNativeApp.IsProtectionEnabled, { url });
    }

    async enableProtection(url: string): Promise<void> {
        const domain = getDomain(url);
        // @ts-ignore
        const linkWithDomain = this.links.removeFromAllowlistLink + domain;
        console.log(linkWithDomain);
        await browser.tabs.create({ url: linkWithDomain });

        // // TODO remove
        // return nativeHostMock.enableProtection();
        //
        // return this.sendNativeMessage(MessagesToNativeApp.EnableProtection);
    }

    async disableProtection(url: string): Promise<void> {
        const domain = getDomain(url);
        // @ts-ignore
        const linkWithDomain = this.links.addToAllowlistLink + domain;
        console.log(linkWithDomain);
        await browser.tabs.create({ url: linkWithDomain });
        // // TODO remove
        // return nativeHostMock.disableProtection();
        //
        // return this.sendNativeMessage(MessagesToNativeApp.DisableProtection);
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

    async getAdvancedRulesText() {
        let rulesText = '';

        // eslint-disable-next-line consistent-return
        const recursiveCall = async () => {
            console.log('send GetAdvancedRulesText');
            const response = await this.sendNativeMessage(MessagesToNativeApp.GetAdvancedRulesText);
            console.log(response);
            if (!response) {
                return;
            }
            const { advanced_rules: advancedRules } = response;
            rulesText += advancedRules;
            await recursiveCall();
        };

        const start = Date.now();
        console.log('started requesting', start);
        await recursiveCall();
        console.log('rules text received', Date.now() - start);

        console.log(rulesText);

        return rulesText;
        // // TODO remove
        // return nativeHostMock.getAdvancedRulesText();
        //
        // return this.sendNativeMessage(MessagesToNativeApp.GetAdvancedRulesText);
    }

    async getInitData(url: string) {
        const result = await this.sendNativeMessage(MessagesToNativeApp.GetInitData, url);

        const {
            add_to_allowlist_link: addToAllowlistLink,
            add_to_blocklist_link: addToBlocklistLink,
            appearance_theme: appearanceTheme,
            content_blockers_enabled: contentBlockersEnabled,
            has_user_rules: hasUserRules,
            premium_app: premiumApp,
            protection_enabled: protectionEnabled,
            remove_all_blocklist_rules_link: removeAllBlocklistRulesLink,
            remove_from_allowlist_link: removeFromAllowlistLink,
        } = result;

        return {
            addToAllowlistLink,
            addToBlocklistLink,
            appearanceTheme,
            contentBlockersEnabled,
            hasUserRules,
            premiumApp,
            protectionEnabled,
            removeAllBlocklistRulesLink,
            removeFromAllowlistLink,
        };
    }
}
