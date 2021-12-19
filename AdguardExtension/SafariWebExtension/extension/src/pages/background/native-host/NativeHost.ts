/* eslint-disable class-methods-use-this */
import browser from 'webextension-polyfill';

import { MessagesToNativeApp } from '../../common/constants';
import { getDomain } from '../../common/utils/url';
import { storage } from '../storage';

interface NativeHostMessage {
    type: MessagesToNativeApp,
    data?: unknown
}

export interface ActionLinks {
    disableSiteProtectionLink: string,
    addToBlocklistLink: string,
    removeAllBlocklistRulesLink: string,
    enableSiteProtectionLink: string,
    upgradeAppLink: string,
    reportProblemLink: string,
    enableAdvancedBlockingLink: string,
    enableSafariProtectionLink: string,
}

type AppearanceTheme = 'system' | 'dark' | 'light';

export interface NativeHostInitData {
    appearanceTheme: AppearanceTheme,
    contentBlockersEnabled: boolean,
    hasUserRules: boolean,
    premiumApp: boolean,
    protectionEnabled: boolean,
    advancedBlockingEnabled: boolean,
    allowlistInverted: boolean,
    safariProtectionEnabled: boolean,
}

export interface NativeHostInterface {
    getInitData(url: string): Promise<NativeHostInitData>
    setLinks(links: ActionLinks): void
    addToUserRules(ruleText: string): Promise<void>
    enableProtection(url: string): Promise<void>
    disableProtection(url: string): Promise<void>
    removeUserRulesBySite(url: string): Promise<void>
    reportProblem(url: string): Promise<void>
    upgradeMe(): Promise<void>
    getAdvancedRulesText(): Promise<string | void>
    enableAdvancedBlocking(): Promise<void>
    shouldUpdateAdvancedRules(): Promise<boolean>
}

export class NativeHost implements NativeHostInterface {
    APP_ID = 'application_id';

    links: ActionLinks | null = null;

    ACTION_LINKS_STORAGE_KEY = 'action_links';

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
     * Return to the tab where user called an action
     * Without this method browser will move to the last open tab in the safari
     * @param tabIdToObserve - tab id which will be intercepted by ios app
     * @param tabIdToReturn - tab id where to return
     * @private
     */
    private returnWhenTabIsIntercepted(tabIdToObserve: number, tabIdToReturn: number) {
        const removeHandler = async (tabId: number) => {
            if (tabId === tabIdToObserve) {
                await browser.tabs.update(tabIdToReturn, { active: true });
                browser.tabs.onRemoved.removeListener(removeHandler);
            }
        };

        browser.tabs.onRemoved.addListener(removeHandler);
    }

    /**
     * Opens tabs with special links, which are intercepted by ios app
     * @param link
     * @private
     */
    private async openNativeLink(link: string) {
        const [currentTab] = await browser.tabs.query({ currentWindow: true, active: true });
        const tab = await browser.tabs.create({ url: link });

        const tabIdToReturn = currentTab?.id;
        const tabIdToObserver = tab?.id;
        if (tabIdToReturn && tabIdToObserver) {
            this.returnWhenTabIsIntercepted(tabIdToObserver, tabIdToReturn);
        }
    }

    /**
     * Saves links in the storage
     * @param links
     */
    async saveLinksInStorage(links: ActionLinks) {
        return storage.set(this.ACTION_LINKS_STORAGE_KEY, links);
    }

    /**
     * Retrieves links from storage
     */
    async getLinksFromStorage(): Promise<ActionLinks | null> {
        const links = await storage.get(this.ACTION_LINKS_STORAGE_KEY);

        if (!links) {
            return null;
        }

        return links as ActionLinks;
    }

    /**
     * Saves action links received from native host
     * @param links
     */
    async setLinks(links: ActionLinks) {
        this.links = links;

        await this.saveLinksInStorage(this.links);
    }

    /**
     * Returns links from memory or from storage;
     */
    async getLinks(): Promise<ActionLinks | null> {
        if (!this.links) {
            this.links = await this.getLinksFromStorage();
        }
        return this.links;
    }

    /**
     * Appends ruleText to the action link sent by native host,
     * and opens new tab with this link
     * @param ruleText
     */
    async addToUserRules(ruleText: string) {
        const links = await this.getLinks();

        if (!links?.addToBlocklistLink) {
            return;
        }

        const linkWithRule = links.addToBlocklistLink + encodeURIComponent(ruleText);
        await this.openNativeLink(linkWithRule);
    }

    async enableProtection(url: string): Promise<void> {
        const links = await this.getLinks();

        if (!links?.enableSiteProtectionLink) {
            return;
        }

        const domain = getDomain(url);
        const linkWithDomain = links.enableSiteProtectionLink + encodeURIComponent(domain);
        await this.openNativeLink(linkWithDomain);
    }

    async disableProtection(url: string): Promise<void> {
        const links = await this.getLinks();

        if (!links?.disableSiteProtectionLink) {
            return;
        }

        const domain = getDomain(url);
        const linkWithDomain = links.disableSiteProtectionLink + encodeURIComponent(domain);
        await this.openNativeLink(linkWithDomain);
    }

    async removeUserRulesBySite(url: string) {
        const links = await this.getLinks();

        if (!links?.removeAllBlocklistRulesLink) {
            return;
        }

        const domain = getDomain(url);
        const linkWithDomain = links.removeAllBlocklistRulesLink + encodeURIComponent(domain);
        await this.openNativeLink(linkWithDomain);
    }

    /**
     * Opens tab with report problem link
     * reportProblemLink already contains url to the website
     */
    async reportProblem() {
        const links = await this.getLinks();
        if (!links?.reportProblemLink) {
            return;
        }

        await browser.tabs.create({ url: links.reportProblemLink });
    }

    async upgradeMe() {
        const links = await this.getLinks();

        if (!links?.upgradeAppLink) {
            return;
        }

        await this.openNativeLink(links.upgradeAppLink);
    }

    async enableAdvancedBlocking() {
        const links = await this.getLinks();

        if (!links?.enableAdvancedBlockingLink) {
            return;
        }

        await this.openNativeLink(links.enableAdvancedBlockingLink);
    }

    /**
     * Retrieves advanced rules text from native host by small parts,
     * so native host won't exceed memory limit
     */
    async getAdvancedRulesText() {
        let rulesText = '';

        const recursiveCall = async (fromBeginning: boolean) => {
            const response = await this.sendNativeMessage(
                MessagesToNativeApp.GetAdvancedRulesText,
                fromBeginning,
            );

            if (!response?.advanced_rules) {
                return;
            }

            rulesText += response.advanced_rules;

            /**
             * Subsequent calls to native host are sent with fromBeginning flag = false,
             * which means to continue return rules from the last point
             */
            await recursiveCall(false);
        };

        /**
         * First call to native host is sent with flag = true,
         * which means start to return rules from the beginning of the file
         */
        await recursiveCall(true);

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
            advanced_blocking_enabled: advancedBlockingEnabled,
            allowlist_inverted: allowlistInverted,
            safari_protection_enabled: safariProtectionEnabled,

            // links
            // e.g. "adguard://safariWebExtension?action=removeFromAllowlist&domain="
            enable_site_protection_link: enableSiteProtectionLink,
            // e.g. "adguard://safariWebExtension?action=addToAllowlist&domain="
            disable_site_protection_link: disableSiteProtectionLink,
            // e.g. "adguard://safariWebExtension?action=addToBlocklist&domain="
            add_to_blocklist_link: addToBlocklistLink,
            // e.g. "adguard://safariWebExtension?action=removeAllBlocklistRules&domain="
            remove_all_blocklist_rules_link: removeAllBlocklistRulesLink,
            // e.g. "adguard://upgradeApp"
            upgrade_app_link: upgradeAppLink,
            // e.g. "https://reports.adguard.com/new_issue.html?browser=Safari&product_version=4.2.1&product_type=iOS"
            report_problem_link: reportProblemLink,
            // e.g. "adguard://enableAdvancedBlocking"
            enable_advanced_blocking_link: enableAdvancedBlockingLink,
            enable_safari_protection_link: enableSafariProtectionLink,
        } = result;

        await this.setLinks({
            addToBlocklistLink,
            disableSiteProtectionLink,
            removeAllBlocklistRulesLink,
            enableSiteProtectionLink,
            upgradeAppLink,
            reportProblemLink,
            enableAdvancedBlockingLink,
            enableSafariProtectionLink,
        });

        return {
            appearanceTheme,
            contentBlockersEnabled,
            hasUserRules,
            premiumApp,
            protectionEnabled,
            advancedBlockingEnabled,
            allowlistInverted,
            safariProtectionEnabled,
        };
    }

    /**
     * Checks if native app has updated rules
     */
    async shouldUpdateAdvancedRules(): Promise<boolean> {
        const response = await this.sendNativeMessage(
            MessagesToNativeApp.ShouldUpdateAdvancedRules,
        );

        if (!response
            || !Object.prototype.hasOwnProperty.call(
                response,
                MessagesToNativeApp.ShouldUpdateAdvancedRules,
            )) {
            return false;
        }

        return !!response[MessagesToNativeApp.ShouldUpdateAdvancedRules];
    }
}
