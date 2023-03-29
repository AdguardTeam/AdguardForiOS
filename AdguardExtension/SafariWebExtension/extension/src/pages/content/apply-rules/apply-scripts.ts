import { log } from '../../common/log';

/**
 * Executes scripts in a page context and removes itself when execution completes.
 *
 * @param scripts Scripts array to execute.
 */
const executeScripts = (scripts: string[]) => {
    // Wrap with try catch
    const start = '( function () { try {';
    const end = "} catch (ex) { console.error('Error executing AG js: ' + ex); } })();";

    const updated = [start, ...scripts, end];

    const scriptTag = document.createElement('script');
    scriptTag.setAttribute('type', 'text/javascript');
    // TODO: check if `;` is needed in the separator for join()
    scriptTag.textContent = updated.join('\r\n');

    const parent = document.head || document.documentElement;
    parent.appendChild(scriptTag);
    if (scriptTag.parentNode) {
        scriptTag.parentNode.removeChild(scriptTag);
    }
};

/**
 * Applies JS injections.
 *
 * @param scripts Array with JS scripts.
 */
export const applyScripts = (scripts: string[]) => {
    if (!scripts || scripts.length === 0) {
        return;
    }

    log.debug(`scripts length: ${scripts.length}`);
    executeScripts(scripts);
};
