import { applyScripts } from './apply-scripts';
import { applyCss } from './apply-css';
import { applyExtendedCss } from './apply-extended-css';
import { logMessage } from './logger';

import { SelectorsAndScripts } from '../../common/interfaces';

/**
 * Applies injected script and css.
 *
 * @param selectorsAndScripts Prepared advanced rules data.
 * @param url Frame url.
 * @param verbose Flag to enable logging.
 */
export const applyAdvancedRules = (selectorsAndScripts: SelectorsAndScripts, url: string, verbose = true): void => {
    logMessage(verbose, 'Applying scripts and css...');
    logMessage(verbose, `Frame url: ${url}`);

    applyScripts(selectorsAndScripts.scripts, verbose);
    applyCss(selectorsAndScripts.cssInject, verbose);
    applyExtendedCss(selectorsAndScripts.cssExtended, verbose);

    logMessage(verbose, 'Applying scripts and css - done');
};

// /**
//  * Applied advanced rules in frame.
//  *
//  * @param url Frame url.
//  * @param cosmeticResult TSUrlFilter's CosmeticResult.
//  */
// export const applyAdvancedRules = (selectorsAndScripts: SelectorsAndScripts): void => {
//     const selectorsAndScripts = prepareAdvancedRules(url, cosmeticResult);
//     applyAdvancedBlockingData(selectorsAndScripts, url, false);
// };
