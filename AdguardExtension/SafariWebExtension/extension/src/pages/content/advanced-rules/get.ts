import browser from 'webextension-polyfill';

import { storage } from '../../common/storage';

import { ADVANCED_RULES_STORAGE_KEY, MessagesToBackgroundPage } from '../../common/constants';

/**
 * Returns advanced rules in string format.
 *
 * First of all, it tries to get the advanced rules from storage.
 * If they are not set yet, it sends a message to the background page to set them.
 * After that, it tries to get the advanced rules from storage again.
 *
 * @returns Advanced rules text as a single string or `null` for no advanced rules.
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
         * We need to be sure that advanced rules are already set in storage and can be retrieved.
         * It can happen just after the app installation
         * on the very first browser start without browser or tabs reload.
         */
        let response;
        try {
            response = await browser.runtime.sendMessage({
                type: MessagesToBackgroundPage.EnsureAdvancedRulesSet,
                data: {},
            });
        } catch (e) {
            // eslint-disable-next-line no-console
            console.log(`Could not ensure advanced rules are set due to: ${e}`);
            return null;
        }

        if (response !== true) {
            // eslint-disable-next-line no-console
            console.log('AG: scripts and selectors were not set to storage');
            return null;
        }

        // FIXME: consider not getting the rules from storage again but from background page as a response
        // FIXME: update the comment after the fix
        // get the advanced rules from storage again
        convertedRulesText = await storage.get(ADVANCED_RULES_STORAGE_KEY) as string;
        if (!convertedRulesText) {
            // eslint-disable-next-line no-console
            console.log('AG: no scripts and selectors received');
            return null;
        }
    }
    return convertedRulesText;
};
