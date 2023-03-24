import { applyScripts } from './apply-scripts';
import { applyCss } from './apply-css';
import { applyExtendedCss } from './apply-extended-css';
import { logMessage } from './logger';

import { prepareAdvancedRules } from '../prepare';

import { SelectorsAndScripts } from '../../../common/interfaces';

/**
 * Applies injected script and css.
 *
 * @param selectorsAndScripts Prepared advanced rules data.
 * @param url Frame url.
 * @param verbose Flag to enable logging.
 */
const applyAdvancedBlockingData = (selectorsAndScripts: SelectorsAndScripts, url: string, verbose = true): void => {
    logMessage(verbose, 'Applying scripts and css...');
    logMessage(verbose, `Frame url: ${url}`);

    applyScripts(selectorsAndScripts.scripts, verbose);
    applyCss(selectorsAndScripts.cssInject, verbose);
    applyExtendedCss(selectorsAndScripts.cssExtended, verbose);

    logMessage(verbose, 'Applying scripts and css - done');
};

/**
 * Applied advanced rules in frame.
 *
 * @param url Frame url.
 * @param rulesText Advanced rules text.
 */
export const applyAdvancedRules = (url: string, rulesText: string): void => {
    let selectorsAndScripts;
    try {
        selectorsAndScripts = prepareAdvancedRules(url, rulesText);
    } catch (e) {
        // eslint-disable-next-line no-console
        console.log(e);
    }

    if (selectorsAndScripts) {
        applyAdvancedBlockingData(selectorsAndScripts, url, false);
    }
};
