import { log } from '../../common/log';

/**
 * Execute scripts in a page context and cleanup itself when execution completes.
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
 * @param verbose Flag to enable logging.
 */
export const applyScripts = (scripts: string[], verbose: boolean) => {
    if (!scripts || scripts.length === 0) {
        return;
    }

    log.verboseInfo(verbose, `scripts length: ${scripts.length}`);
    executeScripts(scripts);
};
