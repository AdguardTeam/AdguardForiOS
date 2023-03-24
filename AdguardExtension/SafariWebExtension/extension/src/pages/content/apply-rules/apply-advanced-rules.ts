import { applyScripts } from './apply-scripts';
import { applyCss } from './apply-css';
import { applyExtendedCss } from './apply-extended-css';

import { log } from '../../common/log';
import { SelectorsAndScripts } from '../../common/interfaces';

/**
 * Applies injected script and css.
 *
 * @param selectorsAndScripts Prepared advanced rules data.
 * @param url Frame url.
 * @param verbose Flag to enable logging.
 */
export const applyAdvancedRules = (selectorsAndScripts: SelectorsAndScripts, url: string, verbose = true): void => {
    log.verboseInfo(verbose, 'Applying scripts and css...');
    log.verboseInfo(verbose, `Frame url: ${url}`);

    applyScripts(selectorsAndScripts.scripts, verbose);
    applyCss(selectorsAndScripts.cssInject, verbose);
    applyExtendedCss(selectorsAndScripts.cssExtended, verbose);

    log.verboseInfo(verbose, 'Applying scripts and css - done');
};
