/* eslint-disable consistent-return */
import browser from 'webextension-polyfill';
import * as TSUrlFilter from '@adguard/tsurlfilter';

import {
    ADVANCED_RULES_STORAGE_KEY,
    MessagesToBackgroundPage,
    MessagesToContentScript,
} from '../common/constants';
import { permissions } from './permissions';
import { log } from '../common/log';
import { app } from './app';
import { storage } from '../common/storage';
import { adguard } from './adguard';

interface Message {
    type: string,
    data?: any,
}

const handleMessages = () => {
    browser.runtime.onMessage.addListener(async (message: Message) => {
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
            case MessagesToBackgroundPage.WakeUp: {
                // do nothing
                break;
            }
            case MessagesToBackgroundPage.EnsureAdvancedRulesSet: {
                await setAdvancedRulesPromise;
                return true;
            }
            default:
                break;
        }
    });
};

/**
 * Gets advanced rules from native host, converts them,
 * and sets the converted result to storage.
 */
const forceUpdateAdvancedRules = async () => {
    const rulesText = await adguard.nativeHost.getAdvancedRulesText();
    const convertedRulesText = TSUrlFilter.RuleConverter.convertRules(rulesText);
    await storage.set(ADVANCED_RULES_STORAGE_KEY, convertedRulesText);
};

/**
 * Sometimes we need to be sure that advanced rules are already set in storage on the background page
 * so they can be retrieved in the content-script.
 * It can happen just after the app installation on the very first browser start without browser or tabs reload.
 */
const setAdvancedRulesPromise = forceUpdateAdvancedRules();

/**
 * Asks the Native Host whether the advanced rules should be updated.
 * If so, then gets advanced rules from native host, converts them,
 * and sets the converted result to storage.
 */
const setAdvancedRulesToStorage = async () => {
    // check whether the advanced rules should be updated in storage
    // to avoid their update on every background page awakening
    const shouldUpdateAdvancedRules = await adguard.nativeHost.shouldUpdateAdvancedRules();
    if (shouldUpdateAdvancedRules) {
        forceUpdateAdvancedRules()
    }
};

// set advanced rules to storage on the background page start
setAdvancedRulesToStorage();

export const background = () => {
    // Message listener should be on the upper level to wake up background page
    // when it is necessary
    handleMessages();
};
