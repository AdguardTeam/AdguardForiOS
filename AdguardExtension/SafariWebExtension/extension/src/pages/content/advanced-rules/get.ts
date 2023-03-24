import browser from 'webextension-polyfill';

import { storage } from '../../common/storage';

import { ADVANCED_RULES_STORAGE_KEY, MessagesToBackgroundPage } from '../../common/constants';

/**
 * Returns advanced rules in string format.
 *
 * First of all, it tries to get the advanced rules from storage.
 * If they are not set yet, it sends a message to the background page to get them.
 *
 * @returns Advanced rules text or `null` for no advanced rules.
 */
export const getAdvancedRulesText = async (): Promise<string | null> => {
    let convertedRulesText = await storage.get(ADVANCED_RULES_STORAGE_KEY) as string;
    /**
     * It might happen that the advanced rules are not set in storage yet.
     * So the type of the variable should be checked in this case,
     * because if advanced rules are set but their length is 0, empty string will be returned.
     */
    if (typeof convertedRulesText === 'undefined') {
        /**
         * There may be a situation when the advanced rules are not set in storage yet.
         * It can happen just after the app installation
         * on the very first browser start without browser or tabs reload.
         */
        let response;
        try {
            response = await browser.runtime.sendMessage({
                type: MessagesToBackgroundPage.GetAdvancedRulesText,
                data: {},
            });
        } catch (e) {
            // eslint-disable-next-line no-console
            console.log(`AG: Could not get advanced rules text from the background page due to: ${e}`);
            return null;
        }

        if (!response) {
            // eslint-disable-next-line no-console
            console.log('AG: no scripts and selectors are received from the background page');
            return null;
        }

        convertedRulesText = response;
    }

    return convertedRulesText;
};
