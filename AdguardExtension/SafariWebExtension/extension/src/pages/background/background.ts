/* eslint-disable consistent-return */
import browser from 'webextension-polyfill';
import { RuleConverter } from '@adguard/tsurlfilter';

import { adguard } from './adguard';
import { app } from './app';
import { permissions } from './permissions';
import type { NativeHostInitData } from './native-host';

import { storage } from '../common/storage';
import { log } from '../common/log';

import {
    ADVANCED_RULES_STORAGE_KEY,
    MessagesToBackgroundPage,
    MessagesToContentScript,
} from '../common/constants';

interface Message {
    type: string,
    data?: any,
}

type PopupData = NativeHostInitData & {
    allSitesAllowed: boolean,
    permissionsModalViewed: boolean,
};

/**
 * Gets advanced rules from the native host and converts them.
 *
 * @returns Converted advanced rules text or `null` for no advanced rules.
 */
const getAdvancedRulesFromNativeHost = async (): Promise<string | null> => {
    const rulesText = await adguard.nativeHost.getAdvancedRulesText();
    return RuleConverter.convertRules(rulesText);
};

// since the message from content script can be sent multiple times (from multiple tabs)
// this variable should not be local to the `setAdvancedRulesToStorage()` function
let lastNativeHostShouldUpdateCallTime = 0;

/**
 * Asks the Native Host whether the advanced rules should be updated.
 * If so, then gets advanced rules from native host, converts them,
 * and sets the converted result to storage.
 *
 * Native Host checking is throttled to avoid frequent calls.
 */
const setAdvancedRulesToStorage = async () => {
    // time to wait before the next call to native host
    const THROTTLE_DELAY_MS = 5 * 1000;

    /**
     * Throttled version of `adguard.nativeHost.shouldUpdateAdvancedRules()`.
     *
     * @returns `false` if the last call was less than {@link THROTTLE_DELAY_MS} ago,
     * or result of `adguard.nativeHost.shouldUpdateAdvancedRules()` otherwise.
     */
    const throttledShouldUpdate = async () => {
        let currentTime = performance.now();

        // if the last call was less than THROTTLE_DELAY ago, return false
        if (currentTime - lastNativeHostShouldUpdateCallTime < THROTTLE_DELAY_MS) {
            return false;
        }
        lastNativeHostShouldUpdateCallTime = currentTime;

        const shouldUpdate = await adguard.nativeHost.shouldUpdateAdvancedRules();
        return shouldUpdate;
    };

    /**
     * Check whether the advanced rules should be updated in storage
     * to avoid their update on every background page awakening
     * or every message {@link MessagesToBackgroundPage.CheckAdvancedRulesUpdate}.
     */
    const shouldUpdateAdvancedRules = await throttledShouldUpdate();
    if (shouldUpdateAdvancedRules) {
        const convertedRulesText = await getAdvancedRulesFromNativeHost();
        await storage.set(ADVANCED_RULES_STORAGE_KEY, convertedRulesText);
    }
};

const handleMessages = () => {
    browser.runtime.onMessage.addListener(async (message: Message): Promise<void | string | null | PopupData> => {
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
            case MessagesToBackgroundPage.CheckAdvancedRulesUpdate: {
                /**
                 * This message is sent by content script to background page
                 * to check if advanced rules should be updated in storage.
                 */
                await setAdvancedRulesToStorage();
            }
            case MessagesToBackgroundPage.GetAdvancedRulesText: {
                /**
                 * Sometimes the content script may request the advanced rules
                 * from the background page instead of getting them from the storage.
                 * It can happen if advanced rules were not set in storage —
                 * just after the app installation
                 * on the very first browser start without browser or tabs reload.
                 */
                const convertedRulesText = await getAdvancedRulesFromNativeHost();
                /**
                 * Received advanced rules should be set to storage.
                 * IMPORTANT: no 'await' for storage.set()
                 * as it will postpone the response to the content script which is not needed.
                 */
                storage.set(ADVANCED_RULES_STORAGE_KEY, convertedRulesText);
                return convertedRulesText;
            }
            default:
                break;
        }
    });
};

export const background = () => {
    // Message listener should be on the upper level to wake up background page
    // when it is necessary
    handleMessages();
};
