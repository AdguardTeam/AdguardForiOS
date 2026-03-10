/* eslint-disable class-methods-use-this */
import browser from 'webextension-polyfill';

import { MessagesToNativeApp, Platform } from '../../common/constants';
import { getDomain } from '../../common/utils/url';
import { storage } from '../../common/storage';
import { ContentScriptData } from '../../common/interfaces';

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

/**
 * Extension state + settings for the website that the user is visiting.
 */
export interface NativeHostInitData {
    /**
     * Application theme.
     */
    appearanceTheme: AppearanceTheme,

    /**
     * Current platform (iPhone or iPad).
     */
    platform: Platform,

    /**
     * True if the app is paid.
     */
    premiumApp: boolean,

    /**
     * True if advanced blocking is enabled in the app.
     * This is a setting that the user can change in the app.
     */
    advancedBlockingEnabled: boolean,

    /**
     * True if Safari protection is enabled in the app.
     * This is a setting that the user can switch in the app.
     */
    safariProtectionEnabled: boolean,

    /**
     * True when at least some content blocking extensions are enabled.
     * The user need to enable at least one content blocking extension
     * in **Safari settings** to have this true.
     */
    contentBlockersEnabled: boolean,

    /**
     * True if the user has enabled "inverted allowlist" in the app settings.
     */
    allowlistInverted: boolean,

    /**
     * Website-specific.
     *
     * True if there are user rules for this website.
     */
    hasUserRules: boolean,

    /**
     * Website-specific.
     *
     * True if protection is enabled for this particular website.
     */
    protectionEnabled: boolean,
}

export interface NativeHostInterface {
    /**
     * Retrieves both the application state and website settings. This data
     * is required for the popup menu initialization.
     *
     * @param url URL of the website.
     */
    getInitData(url: string): Promise<NativeHostInitData>

    /**
     * Retrieves the configuration for the content script that is running on
     * the specified url. topUrl is only set when the url is an iframe.
     *
     * @param url URL of the website.
     * @param topUrl URL of the top-level website.
     */
    getContentScriptData(url: string, topUrl?: string): Promise<ContentScriptData>

    /**
     * Enables protection for the specified website.
     *
     * @param url URL of the website.
     */
    enableProtection(url: string): Promise<void>

    /**
     * Disables protection for the specified website.
     *
     * @param url URL of the website.
     */
    disableProtection(url: string): Promise<void>

    /**
     * Enables Safari protection and makes sure that protection
     * is enabled for the specified website.
     *
     * @param url URL of the website.
     */
    enableSafariProtection(url: string): Promise<void>

    /**
     * Enables advanced blocking.
     */
    enableAdvancedBlocking(): Promise<void>

    /**
     * Adds specified rules to user rules.
     *
     * @param ruleText rule to add
     */
    addToUserRules(ruleText: string): Promise<void>

    /**
     * Removes user rules for the specified website.
     *
     * @param url URL of the website.
     */
    removeUserRulesBySite(url: string): Promise<void>

    /**
     * Opens a page where the user can report an issue with the current
     * website.
     *
     * @param url URL of the website.
     */
    reportProblem(url: string): Promise<void>

    /**
     * Opens a page where the user can upgrade the app.
     */
    upgradeMe(): Promise<void>
}

export class NativeHost implements NativeHostInterface {
    APP_ID = 'application_id';

    links: ActionLinks | null = null;

    ACTION_LINKS_STORAGE_KEY = 'action_links';

    PLATFORM_STORAGE_KEY = 'platform';

    platform: Platform = Platform.IPhone;

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

        /**
         * Fix for opening native urls on ipad https://github.com/AdguardTeam/AdguardForiOS/issues/1878
         * We separated this solution from iphone implementation,
         * because it is not working fully correctly:
         * if user cancels opening application, extension can't open native
         * links until the page is reloaded
         */
        if (await this.getPlatform() === Platform.IPad) {
            await browser.tabs.update(currentTab.id, { url: link });
            return;
        }

        const tab = await browser.tabs.create({ url: link });

        const tabIdToReturn = currentTab?.id;
        const tabIdToObserver = tab?.id;
        if (tabIdToReturn && tabIdToObserver) {
            this.returnWhenTabIsIntercepted(tabIdToObserver, tabIdToReturn);
        }
    }

    async savePlatformInStorage(platform: Platform) {
        return storage.set(this.PLATFORM_STORAGE_KEY, platform);
    }

    async getPlatformFromStorage() {
        const platform = await storage.get(this.PLATFORM_STORAGE_KEY);
        if (!platform) {
            return null;
        }

        return platform as Platform;
    }

    async getPlatform() {
        if (!this.platform) {
            this.platform = await this.getPlatformFromStorage() || Platform.IPhone;
        }

        return this.platform;
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
     * Saves platform data received from native host
     * @param platform
     */
    async setPlatform(platform: Platform) {
        this.platform = platform;

        await this.savePlatformInStorage(this.platform);
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

    async enableSafariProtection(url: string): Promise<void> {
        const links = await this.getLinks();

        if (!links?.enableSafariProtectionLink) {
            return;
        }

        const domain = getDomain(url);
        const linkWithDomain = links.enableSafariProtectionLink + encodeURIComponent(domain);

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
            platform,
            safari_protection_enabled: safariProtectionEnabled,

            // links
            // i.e. "adguard://safariWebExtension?action=removeFromAllowlist&domain="
            enable_site_protection_link: enableSiteProtectionLink,
            // i.e. "adguard://safariWebExtension?action=addToAllowlist&domain="
            disable_site_protection_link: disableSiteProtectionLink,
            // i.e. "adguard://safariWebExtension?action=addToBlocklist&domain="
            add_to_blocklist_link: addToBlocklistLink,
            // i.e. "adguard://safariWebExtension?action=removeAllBlocklistRules&domain="
            remove_all_blocklist_rules_link: removeAllBlocklistRulesLink,
            // i.e. "adguard://upgradeApp"
            upgrade_app_link: upgradeAppLink,
            // i.e. "https://reports.adguard.com/new_issue.html?browser=Safari&product_version=4.2.1&product_type=iOS"
            report_problem_link: reportProblemLink,
            // i.e. "adguard://enableAdvancedBlocking"
            enable_advanced_blocking_link: enableAdvancedBlockingLink,
            // i.e. "adguard://safariWebExtension?action=enableSiteAndSafariProtection?domain="
            enable_safari_protection_link: enableSafariProtectionLink,
        } = result as any;

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

        await this.setPlatform(platform);

        return {
            appearanceTheme,
            contentBlockersEnabled,
            hasUserRules,
            premiumApp,
            protectionEnabled,
            advancedBlockingEnabled,
            allowlistInverted,
            platform,
            safariProtectionEnabled,
        };
    }

    async getContentScriptData(url: string, topUrl?: string): Promise<ContentScriptData> {
        // TODO(ameshkov): Cache this
        const result = await this.sendNativeMessage(MessagesToNativeApp.GetContentScriptData, {
            url,
            topUrl,
        });

        return result as ContentScriptData;
    }
}
