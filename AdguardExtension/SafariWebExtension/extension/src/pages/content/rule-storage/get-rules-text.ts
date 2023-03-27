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
 *
 * @throws An error if messaging with the background page failed
 *
 */
export const getAdvancedRulesText = async (): Promise<string | null> => {
    let rulesText = await storage.get(ADVANCED_RULES_STORAGE_KEY);
    /**
     * It might happen that the advanced rules are not set in storage yet.
     * In this case the type of the variable should be checked,
     * because if advanced rules are set but their length is 0, empty string will be returned.
     * So if the type is not 'string', it means that something went wrong
     * and we need to use an alternative way to get the advanced rules —
     * directly from the background page.
     */
    if (typeof rulesText !== 'string') {
        /**
         * There may be a situation when the advanced rules are not set in storage yet.
         * It can happen just after the app installation
         * on the very first browser start without browser or tabs reload.
         */
        try {
            rulesText = await browser.runtime.sendMessage({
                type: MessagesToBackgroundPage.GetAdvancedRulesText,
            }) as string | null;
        } catch (e) {
            throw new Error(`AG: Could not get advanced rules text from the background page due to: ${e}`);
        }
    }

    if (typeof rulesText === 'string') {
        return rulesText;
    }

    return null;

};
