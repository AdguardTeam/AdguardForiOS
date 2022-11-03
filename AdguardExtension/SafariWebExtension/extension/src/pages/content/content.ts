/* eslint-disable no-console */
import browser from 'webextension-polyfill';
import { ExtendedCss } from '@adguard/extended-css';

import { MessagesToBackgroundPage } from '../common/constants';
import { SelectorsAndScripts } from '../common/interfaces';

/**
 * Logs a message if verbose is true
 *
 * @param verbose
 * @param message
 */
const logMessage = (verbose: boolean, message: string) => {
    if (verbose) {
        console.log(`(AG) ${message}`);
    }
};

const getSelectorsAndScripts = async (): Promise<SelectorsAndScripts | null> => {
    const response = await browser.runtime.sendMessage({
        type: MessagesToBackgroundPage.GetScriptsAndSelectors,
        data: {
            url: window.location.href,
        },
    });

    if (response === null) {
        console.log('AG: no scripts and selectors received');
        return null;
    }

    return response as SelectorsAndScripts;
};

/**
 * Execute scripts in a page context and cleanup itself when execution completes
 * @param scripts Scripts array to execute
 */
const executeScripts = (scripts: string[]) => {
    // Wrap with try catch
    const start = '( function () { try {';
    const end = "} catch (ex) { console.error('Error executing AG js: ' + ex); } })();";

    const updated = [start, ...scripts, end];

    const scriptTag = document.createElement('script');
    scriptTag.setAttribute('type', 'text/javascript');
    scriptTag.textContent = updated.join('\r\n');

    const parent = document.head || document.documentElement;
    parent.appendChild(scriptTag);
    if (scriptTag.parentNode) {
        scriptTag.parentNode.removeChild(scriptTag);
    }
};

/**
 * Applies JS injections.
 * @param scripts Array with JS scripts
 * @param verbose logging
 */
const applyScripts = (scripts: string[], verbose: boolean) => {
    if (!scripts || scripts.length === 0) {
        return;
    }

    logMessage(verbose, `scripts length: ${scripts.length}`);
    executeScripts(scripts);
};

/**
 * Protects specified style element from changes to the current document
 * Add a mutation observer, which is adds our rules again if it was removed
 *
 * @param protectStyleEl protected style element
 */
const protectStyleElementContent = (protectStyleEl: Node) => {
    // @ts-ignore
    const MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
    if (!MutationObserver) {
        return;
    }
    /* observer, which observe protectStyleEl inner changes, without deleting styleEl */
    const innerObserver = new MutationObserver(((mutations) => {
        for (let i = 0; i < mutations.length; i += 1) {
            const m = mutations[i];
            // @ts-ignore
            if (protectStyleEl.hasAttribute('mod') && protectStyleEl.getAttribute('mod') === 'inner') {
                // @ts-ignore
                protectStyleEl.removeAttribute('mod');
                break;
            }

            // @ts-ignore
            protectStyleEl.setAttribute('mod', 'inner');
            let isProtectStyleElModified = false;

            /**
             * further, there are two mutually exclusive situations: either there were changes
             * the text of protectStyleEl, either there was removes a whole child "text"
             * element of protectStyleEl we'll process both of them
             */
            if (m.removedNodes.length > 0) {
                for (let j = 0; j < m.removedNodes.length; j += 1) {
                    isProtectStyleElModified = true;
                    protectStyleEl.appendChild(m.removedNodes[j]);
                }
            } else if (m.oldValue) {
                isProtectStyleElModified = true;
                // eslint-disable-next-line no-param-reassign
                protectStyleEl.textContent = m.oldValue;
            }

            if (!isProtectStyleElModified) {
                // @ts-ignore
                protectStyleEl.removeAttribute('mod');
            }
        }
    }));

    innerObserver.observe(protectStyleEl, {
        childList: true,
        characterData: true,
        subtree: true,
        characterDataOldValue: true,
    });
};

/**
 * Applies css stylesheet
 * @param styleSelectors Array of stylesheets or selectors
 * @param verbose logging
 */
const applyCss = (styleSelectors: string[], verbose: boolean) => {
    if (!styleSelectors || !styleSelectors.length) {
        return;
    }

    logMessage(verbose, `css length: ${styleSelectors.length}`);

    const styleElement = document.createElement('style');
    styleElement.setAttribute('type', 'text/css');
    (document.head || document.documentElement).appendChild(styleElement);

    const selectors = styleSelectors.map((s) => s.trim());

    selectors.forEach((selector) => {
        try {
            styleElement.sheet?.insertRule(selector);
        } catch (e) {
            logMessage(verbose, `Was unable to inject selector: ${selector}, due to error: ${e}`);
        }
    });

    protectStyleElementContent(styleElement);
};

/**
 * Applies Extended Css stylesheet
 *
 * @param extendedCss Array with ExtendedCss stylesheets
 * @param verbose logging
 */
const applyExtendedCss = (extendedCss: string[], verbose: boolean) => {
    if (!extendedCss || !extendedCss.length) {
        return;
    }

    logMessage(verbose, `extended css length: ${extendedCss.length}`);
    const extCss = new ExtendedCss({
        styleSheet: extendedCss
            .filter((s) => s.length > 0)
            .map((s) => s.trim())
            .map((s) => (s[s.length - 1] !== '}' ? `${s} {display:none!important;}` : s))
            .join('\n'),
    });
    extCss.apply();
};

/**
 * Applies injected script and css
 *
 * @param selectorsAndScripts
 * @param verbose
 */
const applyAdvancedBlockingData = (selectorsAndScripts: SelectorsAndScripts, verbose = true) => {
    logMessage(verbose, 'Applying scripts and css..');
    logMessage(verbose, `Frame url: ${window.location.href}`);

    applyScripts(selectorsAndScripts.scripts, verbose);
    applyCss(selectorsAndScripts.cssInject, verbose);
    applyExtendedCss(selectorsAndScripts.cssExtended, verbose);

    logMessage(verbose, 'Applying scripts and css - done');
};

const init = async () => {
    if (document instanceof HTMLDocument) {
        if (window.location.href && window.location.href.indexOf('http') === 0) {
            const startGettingScripts = Date.now();
            let selectorsAndScripts;
            try {
                selectorsAndScripts = await getSelectorsAndScripts();
            } catch (e) {
                console.log(e);
            }

            console.log(`Time to get selectors and scripts from native page to content script: ${Date.now() - startGettingScripts} ms`);

            if (selectorsAndScripts) {
                applyAdvancedBlockingData(selectorsAndScripts, false);
            }
        }
    }
};

export const content = {
    init,
};
