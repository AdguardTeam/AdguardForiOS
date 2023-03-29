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
 */
export const applyAdvancedRules = (selectorsAndScripts: SelectorsAndScripts, url: string): void => {
    log.debug('Applying scripts and css...');
    log.debug(`Frame url: ${url}`);

    applyScripts(selectorsAndScripts.scripts);
    applyCss(selectorsAndScripts.cssInject);
    applyExtendedCss(selectorsAndScripts.cssExtended);

    log.debug('Applying scripts and css - done');
};
