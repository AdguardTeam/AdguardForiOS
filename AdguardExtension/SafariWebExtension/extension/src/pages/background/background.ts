/* eslint-disable consistent-return */
import { browser } from 'webextension-polyfill-ts';

import {
    MessagesToBackgroundPage,
    MessagesToContentScript,
    MessagesToNativeApp,
} from '../common/constants';
import { permissions } from './permissions';
import { log } from '../common/log';
import { app } from './app';
import { nativeHost } from './native-host';
import { Engine } from './engine';
import { getDomain } from '../common/utils/url';
import { buildStyleSheet } from './css-service';
import { SelectorsAndScripts } from '../common/interfaces';

interface Message {
    type: string,
    data?: any,
}

const getEngine = (() => {
    const engine = new Engine();
    let startPromise: Promise<Engine>;

    const start = async () => {
        const rulesText = await nativeHost.getAdvancedRulesText();
        await engine.start(rulesText);
        return engine;
    };

    return () => {
        if (!startPromise) {
            startPromise = start();
        }
        return startPromise;
    };
})();

const getScriptsAndSelectors = async (url: string): Promise<SelectorsAndScripts> => {
    const engine = await getEngine();

    const hostname = getDomain(url);
    const cosmeticResult = engine.getCosmeticResult(hostname);

    const injectCssRules = [
        ...cosmeticResult.CSS.generic,
        ...cosmeticResult.CSS.specific,
    ];

    const elementHidingExtCssRules = [
        ...cosmeticResult.elementHiding.genericExtCss,
        ...cosmeticResult.elementHiding.specificExtCss,
    ];

    const injectExtCssRules = [
        ...cosmeticResult.CSS.genericExtCss,
        ...cosmeticResult.CSS.specificExtCss,
    ];

    const cssInject = buildStyleSheet([], injectCssRules, true);
    const cssExtended = buildStyleSheet(
        elementHidingExtCssRules,
        injectExtCssRules,
        false,
    );

    const scriptRules = cosmeticResult.getScriptRules();

    const debug = true;
    const scripts = scriptRules
        .map((scriptRule) => scriptRule.getScript(debug))
        .filter((script): script is string => script !== null);

    // remove repeating scripts
    const uniqueScripts = [...new Set(scripts)];

    return {
        scripts: uniqueScripts,
        cssInject,
        cssExtended,
    };
};

const handleMessages = () => {
    browser.runtime.onMessage.addListener(async (message: Message) => {
        // @ts-ignore
        const { type, data } = message;

        switch (type) {
            case MessagesToBackgroundPage.GetScriptsAndSelectors: {
                const { url } = data;
                const scriptsAndSelectors = await getScriptsAndSelectors(url);
                return scriptsAndSelectors as SelectorsAndScripts;
            }
            case MessagesToBackgroundPage.AddRule: {
                await nativeHost.addToUserRules(data.ruleText);
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
                // TODO consider possibility to join native host calls
                const protectionEnabled = await nativeHost.isProtectionEnabled(url);
                const hasUserRules = await nativeHost.hasUserRulesBySite(url);
                const premiumApp = await nativeHost.isPremiumApp();
                const contentBlockersEnabled = await nativeHost.areContentBlockersEnabled();

                return {
                    allSitesAllowed,
                    permissionsModalViewed,
                    protectionEnabled,
                    hasUserRules,
                    premiumApp,
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
    // Message listener should be on the upper level to wake up background page
    // when it is necessary
    handleMessages();
};
