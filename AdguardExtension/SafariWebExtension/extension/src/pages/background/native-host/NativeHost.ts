/* eslint-disable class-methods-use-this */
import browser from 'webextension-polyfill';

import { MessagesToNativeApp } from '../../common/constants';
import { getDomain } from '../../common/utils/url';

interface NativeHostMessage {
    type: MessagesToNativeApp,
    data?: unknown
}

export interface ActionLinks {
    addToAllowlistLink: string,
    addToBlocklistLink: string,
    removeAllBlocklistRulesLink: string,
    removeFromAllowlistLink: string,
    upgradeAppLink: string,
    reportProblemLink: string,
}

type AppearanceTheme = 'system' | 'dark' | 'light';

interface NativeHostInitData {
    appearanceTheme: AppearanceTheme,
    contentBlockersEnabled: boolean,
    hasUserRules: boolean,
    premiumApp: boolean,
    protectionEnabled: boolean,
}

export interface NativeHostInterface {
    getInitData(url: string): Promise<NativeHostInitData>
    setLinks(links: ActionLinks): void
    addToUserRules(ruleText: string): Promise<void>
    enableProtection(url: string): Promise<void>
    disableProtection(url: string): Promise<void>
    removeUserRulesBySite(url: string): Promise<void>
    reportProblem(url: string): Promise<void>
    upgradeMe(): void
    getAdvancedRulesText(): Promise<string | void>
}

export class NativeHost implements NativeHostInterface {
    APP_ID = 'application_id';

    links: ActionLinks | null = null;

    /**
     * Sends message to the native messaging host
     * @param type
     * @param data
     * @private
     */
    private async sendNativeMessage(type: MessagesToNativeApp, data?: unknown) {
        const message: NativeHostMessage = { type };
        if (data) {
            message.data = data;
        }

        return browser.runtime.sendNativeMessage(this.APP_ID, message);
    }

    /**
     * Saves action links received from native host
     * @param links
     */
    setLinks(links: ActionLinks) {
        this.links = links;
    }

    /**
     * Appends ruleText to the action link sent by native host,
     * and opens new tab with this link
     * @param ruleText
     */
    async addToUserRules(ruleText: string) {
        if (!this.links?.addToBlocklistLink) {
            return;
        }

        const linkWithDomain = this.links.addToBlocklistLink + ruleText;
        await browser.tabs.create({ url: linkWithDomain });
    }

    async enableProtection(url: string): Promise<void> {
        if (!this.links?.removeFromAllowlistLink) {
            return;
        }

        const domain = getDomain(url);
        const linkWithDomain = this.links.removeFromAllowlistLink + domain;
        await browser.tabs.create({ url: linkWithDomain });
    }

    async disableProtection(url: string): Promise<void> {
        if (!this.links?.addToAllowlistLink) {
            return;
        }

        const domain = getDomain(url);
        const linkWithDomain = this.links.addToAllowlistLink + domain;
        await browser.tabs.create({ url: linkWithDomain });
    }

    async removeUserRulesBySite(url: string) {
        if (!this.links?.removeAllBlocklistRulesLink) {
            return;
        }

        const domain = getDomain(url);
        const linkWithDomain = this.links.removeAllBlocklistRulesLink + domain;
        await browser.tabs.create({ url: linkWithDomain });
    }

    // FIXME shouldn't here provided url?
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    async reportProblem(url?: string) {
        if (!this.links?.reportProblemLink) {
            return;
        }

        await browser.tabs.create({ url: this.links.reportProblemLink });
    }

    async upgradeMe() {
        if (!this.links?.upgradeAppLink) {
            return;
        }

        await browser.tabs.create({ url: this.links.upgradeAppLink });
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

    async getInitData(url: string): Promise<NativeHostInitData> {
        const result = await this.sendNativeMessage(MessagesToNativeApp.GetInitData, url);

        const {
            protection_enabled: protectionEnabled,
            has_user_rules: hasUserRules,
            premium_app: premiumApp,
            appearance_theme: appearanceTheme,
            content_blockers_enabled: contentBlockersEnabled,

            // links
            // e.g. "adguard://safariWebExtension?action=removeFromAllowlist&domain="
            remove_from_allowlist_link: removeFromAllowlistLink,
            // e.g. "adguard://safariWebExtension?action=addToAllowlist&domain="
            add_to_allowlist_link: addToAllowlistLink,
            // e.g. "adguard://safariWebExtension?action=addToBlocklist&domain="
            add_to_blocklist_link: addToBlocklistLink,
            // e.g. "adguard://safariWebExtension?action=removeAllBlocklistRules&domain="
            remove_all_blocklist_rules_link: removeAllBlocklistRulesLink,
            // e.g. "adguard://upgradeApp"
            upgrade_app_link: upgradeAppLink,
            // e.g. "https://reports.adguard.com/new_issue.html?browser=Safari&product_version=4.2.1&product_type=iOS"
            report_problem_link: reportProblemLink,
        } = result;

        this.setLinks({
            addToBlocklistLink,
            addToAllowlistLink,
            removeAllBlocklistRulesLink,
            removeFromAllowlistLink,
            upgradeAppLink,
            reportProblemLink,
        });

        return {
            appearanceTheme,
            contentBlockersEnabled,
            hasUserRules,
            premiumApp,
            protectionEnabled,
        };
    }
}
