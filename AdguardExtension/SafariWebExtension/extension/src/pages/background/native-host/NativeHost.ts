/* eslint-disable class-methods-use-this */
import { browser } from 'webextension-polyfill-ts';

import { MessagesToNativeApp } from '../../common/constants';
import { getDomain } from '../../common/utils/url';

interface NativeHostMessage {
    type: MessagesToNativeApp,
    data?: unknown
}

interface ActionLinks {
    addToAllowlistLink: string,
    addToBlocklistLink: string,
    removeAllBlocklistRulesLink: string,
    removeFromAllowlistLink: string,
}

export class NativeHost {
    APP_ID = 'application_id';

    links: ActionLinks | null = null;

    private async sendNativeMessage(type: MessagesToNativeApp, data?: unknown) {
        const message: NativeHostMessage = { type };
        if (data) {
            message.data = data;
        }

        return browser.runtime.sendNativeMessage(this.APP_ID, message);
    }

    setLinks(links: ActionLinks) {
        this.links = links;
    }

    async addToUserRules(ruleText: string) {
        if (!this.links) {
            return;
        }

        const linkWithDomain = this.links.addToBlocklistLink + ruleText;
        await browser.tabs.create({ url: linkWithDomain });
    }

    async enableProtection(url: string): Promise<void> {
        if (!this.links) {
            return;
        }

        const domain = getDomain(url);
        const linkWithDomain = this.links.removeFromAllowlistLink + domain;
        await browser.tabs.create({ url: linkWithDomain });
    }

    async disableProtection(url: string): Promise<void> {
        if (!this.links) {
            return;
        }

        const domain = getDomain(url);
        const linkWithDomain = this.links.addToAllowlistLink + domain;
        await browser.tabs.create({ url: linkWithDomain });
    }

    async removeUserRulesBySite(url: string) {
        if (!this.links) {
            return;
        }

        const domain = getDomain(url);
        // TODO shouldn't here to be provided url, not domain
        const linkWithDomain = this.links.removeAllBlocklistRulesLink + domain;
        await browser.tabs.create({ url: linkWithDomain });
    }

    // TODO get link from native host
    reportProblem(url?: string) {
        const type = MessagesToNativeApp.ReportProblem;

        if (url) {
            return this.sendNativeMessage(type, { url });
        }

        return this.sendNativeMessage(type);
    }

    // TODO get link from native host
    upgradeMe() {
        return this.sendNativeMessage(MessagesToNativeApp.UpgradeMe);
    }

    // TODO add timeout and handle errors
    async getAdvancedRulesText() {
        let rulesText = '';

        const recursiveCall = async () => {
            const response = await this.sendNativeMessage(MessagesToNativeApp.GetAdvancedRulesText);
            if (!response) {
                return;
            }

            rulesText += response.advanced_rules;
            await recursiveCall();
        };

        await recursiveCall();

        return rulesText;
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
