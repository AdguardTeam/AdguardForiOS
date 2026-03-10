/**
 * @file Content script for the WebExtension.
 *
 * This script runs in the context of a web page, and it's responsible for:
 * - Requesting necessary configuration (rules) from the background script.
 * - Initializing the content script by applying those configurations.
 * - Managing event dispatching with a slight delay to capture important page
 * events.
 */

import browser from 'webextension-polyfill';
import { ContentScript, setupDelayedEventDispatcher } from '@adguard/safari-extension';
import { ContentScriptData } from '../common/interfaces';
import { log } from '../common/log';
import { MessagesToBackgroundPage } from '../common/constants';

// The delay of 1000ms is used as a buffer to capture critical initial events
// while waiting for the rules response.
const DELAY_EVENTS_MS = 1000;

// Initialize the delayed event dispatcher. This may intercept DOMContentLoaded
// and load events. The idea is to delay `load` and `DOMContentLoaded` so that
// they fire AFTER scriptlets and JS rules are executed. This may help on some
// websites where scriptlets timing is important. It won't completely solve all
// issues, but it's a simple way to improve the situation.
const cancelDelayedDispatchAndDispatch = setupDelayedEventDispatcher(DELAY_EVENTS_MS);

// Save the time when the content script was initialized.
const initTime = Date.now();

/**
 * Print timing information that can be helpful to debug performance issues.
 *
 * @param contentScriptData Content script data received from the background.
 */
const printTiming = (contentScriptData: ContentScriptData) => {
    const nativeHostAge = Date.now() - contentScriptData.init_ts;
    const elapsedTotal = Date.now() - initTime;
    const elapsedRequest = contentScriptData.request_received_ts - initTime;
    const elapsedNative = contentScriptData.response_created_ts
        - contentScriptData.request_received_ts;

    log.debug(`Native host age: ${nativeHostAge}ms`);
    log.debug(`Elapsed on getting content script data: ${elapsedTotal}ms`);

    if (!contentScriptData.cached) {
        log.debug(`Elapsed on messaging to native host: ${elapsedRequest}ms`);
        log.debug(`Elapsed on native host processing: ${elapsedNative}ms`);
    }
};

// Declare global window object with `adguard` property so that we could
// expose ContentScript to other scripts in the ISOLATED world, this way
// it can be called by scripts injected by `browser.scripting.executeScript`.
declare global {
    interface Window {
        adguard: {
            contentScript: ContentScript;
        };
    }
}

/**
 * Main entry point function for the content script.
 *
 * This function:
 * 1. Requests configuration (rules) from the background script.
 * 2. Checks and applies the configuration if available.
 */
const init = async () => {
    // Log that the content script process has started.
    log.debug(`Content script is starting on ${window.location.href} (iframe=${window === window.top})...`);

    // First of all, make sure that the content script is exposed to the
    // scripts that will be called by background script.
    const contentScript = new ContentScript();
    window.adguard = {
        contentScript,
    };

    // Request the content script data from the background page.
    const contentScriptData: ContentScriptData = await browser.runtime.sendMessage({
        type: MessagesToBackgroundPage.RequestContentScriptData,
    });

    printTiming(contentScriptData);

    if (contentScriptData.configuration) {
        // Normally, we shouldn't get here as the rules are applied by the
        // background page. But in the case of about: frames we need to apply
        // the rules here.
        log.debug(`Found rules for the website ${window.location.href}`);

        // Run the content script with the provided configuration.
        contentScript.applyConfiguration(contentScriptData.configuration);

        log.debug(`The rules have been applied for the website ${window.location.href}`);
    } else {
        // This may mean that the rules were actually applied by the background
        // page.
        log.debug(`No rules returned for the website ${window.location.href}`);
    }

    // After processing, cancel any pending delayed event dispatch and process
    // any queued events immediately.
    cancelDelayedDispatchAndDispatch();
};

export const content = {
    init,
};
