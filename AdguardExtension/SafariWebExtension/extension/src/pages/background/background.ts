/* eslint-disable consistent-return */
import browser from 'webextension-polyfill';
import * as TSUrlFilter from '@adguard/tsurlfilter';

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
    return TSUrlFilter.RuleConverter.convertRules(rulesText);
};

/**
 * Handles messages which are sent to the background page.
 *
 * @param message Message with type as {@link MessagesToBackgroundPage} and optional data object.
 * @returns Promise.
 */
const messageHandler = async (message: Message): Promise<void | string | null | PopupData> => {
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
            // do nothing as the message is sent by content script
            // only to wake up background page in order to set advanced rules to storage
            break;
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
};

/**
 * Wrapper for async listener.
 * It is needed for preventing other listeners from responding
 * if more  than one message is sent to the background page.
 * {@see @link https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/runtime/onMessage}.
 *
 * @param message Message with type as {@link MessagesToBackgroundPage} and optional data object.
 * @returns Promise.
 */
const asyncHandlerWrapper = (message: Message): Promise<void | string | null | PopupData> => {
    return messageHandler(message)
        .then((data) => data)
        .catch((e) => log.error(e));
};

const handleMessages = () => {
    browser.runtime.onMessage.addListener(asyncHandlerWrapper);
};

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
        const convertedRulesText = await getAdvancedRulesFromNativeHost();
        await storage.set(ADVANCED_RULES_STORAGE_KEY, convertedRulesText);
    }
};

// set advanced rules to storage on the background page start
setAdvancedRulesToStorage();

export const background = () => {
    // Message listener should be on the upper level to wake up background page
    // when it is necessary
    handleMessages();
};
