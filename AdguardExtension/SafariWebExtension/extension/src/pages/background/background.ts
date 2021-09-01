/* eslint-disable consistent-return */
import { browser } from 'webextension-polyfill-ts';

import {
    MessagesToBackgroundPage,
    MessagesToContentScript,
    MessagesToNativeApp,
} from '../common/constants';
import { permissions } from './permissions';
import { logNative } from '../common/logNative';
import { log } from '../common/log';
import { app } from './app';
import { nativeHost } from './native-host';

interface Message {
    type: string,
    data?: any,
}

const handleMessages = () => {
    browser.runtime.onMessage.addListener(async (message: Message) => {
        // @ts-ignore
        const { type, data } = message;

        switch (type) {
            case MessagesToBackgroundPage.GetScriptsAndSelectors: {
                // return handleScriptsAndSelectorsGeneration(data.url);
                const start = Date.now();
                const response = await browser.runtime.sendNativeMessage('application_id', {
                    type: MessagesToNativeApp.GetBlockingData,
                    data: data.url,
                });
                logNative(`AG: Time to get blocking data from native host app: ${Date.now() - start} ms`);
                return response.data;
            }
            case MessagesToBackgroundPage.AddRule: {
                await browser.runtime.sendNativeMessage('application_id', {
                    type: MessagesToNativeApp.AddToUserRules,
                    data: data.ruleText,
                });
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
                const { url, value } = data;

                const allSitesAllowed = await permissions.areAllSitesAllowed();
                const permissionsModalViewed = await app.isPermissionsModalViewed();
                // TODO consider possibility to join native host calls
                const protectionEnabled = await nativeHost.isProtectionEnabled(url);
                const hasUserRules = await nativeHost.hasUserRulesBySite(url);
                const premiumApp = await nativeHost.isPremiumApp();
                const appearanceTheme = await nativeHost.appearanceTheme(value);
                const contentBlockersEnabled = await nativeHost.areContentBlockersEnabled();

                return {
                    allSitesAllowed,
                    permissionsModalViewed,
                    protectionEnabled,
                    hasUserRules,
                    premiumApp,
                    appearanceTheme,
                    contentBlockersEnabled,
                };
            }
            case MessagesToBackgroundPage.SetProtectionStatus: {
                const { enabled } = data;
                if (enabled) {
                    return nativeHost.enableProtection();
                }
                return nativeHost.disableProtection();
            }
            case MessagesToBackgroundPage.ReportProblem: {
                const { url } = data;
                return nativeHost.reportProblem(url);
            }
            case MessagesToBackgroundPage.UpgradeClicked: {
                await nativeHost.upgradeMe();
                break;
            }
            default:
                break;
        }
    });
};

export const background = () => {
    // logNative(`application started ${Date.now()}`);
    // Message listener should be on the upper level to wake up background page
    // when it is necessary
    handleMessages();
};
