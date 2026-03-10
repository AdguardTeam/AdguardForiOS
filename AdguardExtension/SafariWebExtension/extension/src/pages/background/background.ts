/* eslint-disable consistent-return */
import browser from 'webextension-polyfill';
import { adguard } from './adguard';
import { engine } from './engine';
import { app } from './app';
import { permissions } from './permissions';
import type { NativeHostInitData } from './native-host';
import { log } from '../common/log';

import {
    MessagesToBackgroundPage,
    MessagesToContentScript,
} from '../common/constants';
import { ContentScriptData } from '../common/interfaces';

/**
 * Represents a message to the background page.
 */
interface Message {
    type: string,
    data?: any,
}

type MessageSender = browser.Runtime.MessageSender;

/**
 * NativeHostInitData extended with the information regarding the extension
 * permissions. In Safari the extension may have either full access to all
 * URLs or limited access to specific websites.
 */
type PopupData = NativeHostInitData & {
    /**
     * If true the extension is allowed to access all websites.
     */
    allSitesAllowed: boolean,

    /**
     * If true, the user has already seen the "limited permissions" dialog
     * that we show to those who have not granted access to all websites.
     */
    permissionsModalViewed: boolean,
};

/**
 * Response message types.
 */
type ResponseMessage = void | string | null | PopupData | ContentScriptData;

/**
 * Handles messages from the content script.
 */
const handleMessages = async (message: Message, sender: MessageSender): Promise<ResponseMessage> => {
    const { type, data } = message;

    switch (type) {
        case MessagesToBackgroundPage.AddRule: {
            await adguard.nativeHost.addToUserRules(data.ruleText);
            break;
        }
        case MessagesToBackgroundPage.OpenAssistant: {
            let { tabId } = data;

            if (!tabId) {
                const [tab] = await browser.tabs.query({ active: true, currentWindow: true });
                if (!tab.id) {
                    log.error('Was unable to get active tab');
                    return;
                }
                tabId = tab.id;
            }

            await browser.tabs.executeScript(tabId, { file: 'assistant.js' });

            // init assistant
            await browser.tabs.sendMessage(tabId, {
                type: MessagesToContentScript.InitAssistant,
                data: { addRuleCallbackName: MessagesToBackgroundPage.AddRule },
            });
            break;
        }
        case MessagesToBackgroundPage.SetPermissionsModalViewed: {
            return app.setPermissionsModalViewed();
        }
        case MessagesToBackgroundPage.GetPopupData: {
            const { url } = data;

            const allSitesAllowed = await permissions.areAllSitesAllowed();
            const permissionsModalViewed = await app.isPermissionsModalViewed();

            const {
                protectionEnabled,
                hasUserRules,
                premiumApp,
                appearanceTheme,
                contentBlockersEnabled,
                advancedBlockingEnabled,
                safariProtectionEnabled,
                allowlistInverted,
                platform,
            } = await adguard.nativeHost.getInitData(url);

            return {
                allSitesAllowed,
                permissionsModalViewed,
                protectionEnabled,
                hasUserRules,
                premiumApp,
                appearanceTheme,
                contentBlockersEnabled,
                advancedBlockingEnabled,
                safariProtectionEnabled,
                allowlistInverted,
                platform,
            };
        }
        case MessagesToBackgroundPage.SetProtectionStatus: {
            const { enabled, url } = data;
            if (enabled) {
                return adguard.nativeHost.enableProtection(url);
            }
            return adguard.nativeHost.disableProtection(url);
        }
        case MessagesToBackgroundPage.EnableSafariProtection: {
            const { url } = data;
            return adguard.nativeHost.enableSafariProtection(url);
        }
        case MessagesToBackgroundPage.ReportProblem: {
            const { url } = data;
            return adguard.nativeHost.reportProblem(url);
        }
        case MessagesToBackgroundPage.UpgradeClicked: {
            await adguard.nativeHost.upgradeMe();
            break;
        }
        case MessagesToBackgroundPage.EnableAdvancedBlocking: {
            await adguard.nativeHost.enableAdvancedBlocking();
            break;
        }
        case MessagesToBackgroundPage.DeleteUserRulesByUrl: {
            const { url } = data;
            await adguard.nativeHost.removeUserRulesBySite(url);
            break;
        }
        case MessagesToBackgroundPage.RequestContentScriptData: {
            const tabId = sender.tab?.id ?? 0;
            const frameId = sender.frameId ?? 0;
            let blankFrame = false;

            let url = sender.url || '';
            const topUrl = frameId === 0 ? undefined : sender.tab?.url;

            if (!url.startsWith('http') && topUrl) {
                // Handle the case of non-HTTP iframes, i.e. frames created by
                // JS. For instance, frames can be created as 'about:blank' or
                // 'about:srcdoc'.
                url = topUrl;
                blankFrame = true;
            }

            const contentScriptData = await engine.lookup(url, topUrl);

            // In the current Safari version we cannot apply rules to blank
            // frames from the background: https://bugs.webkit.org/show_bug.cgi?id=296702
            //
            // In this case we fallback to using the content script to apply
            // rules. The downside here is that the content script cannot
            // override website's CSPs.
            if (!blankFrame && contentScriptData.configuration) {
                await engine.applyConfiguration(tabId, frameId, contentScriptData.configuration);

                // Make sure that the configuration is not returned to the
                // content script as the configuration has been already applied
                // by engine.
                contentScriptData.configuration = undefined;
            }

            return contentScriptData;
        }
        default:
            break;
    }

    return null;
};

export const background = () => {
    // Message listener should be on the upper level to wake up background page
    // when it is necessary.
    browser.runtime.onMessage.addListener(async (message: unknown, sender: browser.Runtime.MessageSender) => {
        return handleMessages(message as Message, sender);
    });
};
