import { logMessage } from './logger';

/**
 * Protects specified style element from changes to the current document.
 * Add a mutation observer, which is adds our rules again if it was removed.
 *
 * @param protectStyleEl Protected style element.
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
             * Further, there are two mutually exclusive situations: either there were changes
             * the text of protectStyleEl, either there was removes a whole child "text"
             * element of protectStyleEl we'll process both of them.
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
 * Applies css stylesheet.
 *
 * @param styleSelectors Array of stylesheets or selectors.
 * @param verbose Flag to enable logging.
 */
export const applyCss = (styleSelectors: string[], verbose: boolean): void => {
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
