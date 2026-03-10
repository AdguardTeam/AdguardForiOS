import { BackgroundScript, Configuration } from '@adguard/safari-extension';
import { ContentScriptData } from '../common/interfaces';
import { adguard } from './adguard';

/**
 * Engine is a class that handles the communication between the background
 * script and the native host, retrieves content script configuration from
 * there and caches it in the background.
 */
class Engine {
    /**
     * Global variable to track the engine timestamp. This value is used to
     * invalidate the cache when the underlying engine is updated.
     */
    private engineTimestamp = 0;

    /**
     * BackgroundScript is used to apply filtering configuration to web pages.
     * Note, that it relies on the content script to be injected into the page
     * and available in the ISOLATED world via `adguard.contentScript` object.
     */
    private backgroundScript = new BackgroundScript();

    /**
     * Cache to store the rules for a given URL. The key is a URL (string) and
     * the value is a ContentScriptData object. Caching responses allows us to
     * respond to content script requests quickly while also updating the cache
     * in the background.
     */
    private cache = new Map<string, ContentScriptData>();

    /**
     * Returns a cache key for the given URL and top-level URL.
     */
    private cacheKey = (url: string, topUrl?: string) => `${url}#${topUrl ?? ''}`;

    /**
     * Retrieves the configuration for the content script that is running on
     * the specified url from the cache.
     *
     * @param url URL of the website.
     * @param topUrl URL of the top-level website.
     * @returns The configuration for the content script.
     */
    private getFromCache = (url: string, topUrl?: string): ContentScriptData | undefined => {
        const key = this.cacheKey(url, topUrl);
        const cachedData = this.cache.get(key);

        if (cachedData) {
            // Make sure to copy the object so that the user wouldn't be able
            // to mutate the cached data.
            const data = {
                ...cachedData,
            };

            return data;
        }

        return undefined;
    };

    /**
     * Saves the configuration for the content script that is running on
     * the specified url to the cache.
     *
     * @param url URL of the website.
     * @param topUrl URL of the top-level website.
     * @param data The configuration for the content script.
     */
    private saveToCache = (url: string, topUrl: string | undefined, data: ContentScriptData) => {
        const key = this.cacheKey(url, topUrl);
        this.cache.set(key, {
            ...data,
            // Mark as cached.
            cached: true,
        });
    };

    /**
     * Retrieves the configuration for the content script that is running on
     * the specified url from the native process. Stores the retrieved
     * configuration in the cache.
     *
     * @param url URL of the website.
     * @param topUrl URL of the top-level website.
     * @returns The configuration for the content script.
     */
    private lookupNative = async (url: string, topUrl?: string): Promise<ContentScriptData> => {
        // Send the request to the native messaging host and wait for the response.
        const data = await adguard.nativeHost.getContentScriptData(url, topUrl);

        const { configuration } = data;

        // If the engine timestamp has been updated, clear the cache and update
        // the timestamp.
        if (configuration && configuration.engineTimestamp !== this.engineTimestamp) {
            this.cache.clear();
            this.engineTimestamp = configuration.engineTimestamp;
        }

        // Save the new message in the cache for the given URL.
        this.saveToCache(url, topUrl, data);

        return data;
    };

    /**
     * Retrieves the configuration for the content script that is running on
     * the specified url. topUrl is only set when the url is an iframe.
     *
     * @param url URL of the website.
     * @param topUrl URL of the top-level website.
     */
    public lookup = async (url: string, topUrl?: string): Promise<ContentScriptData> => {
        const cachedData = this.getFromCache(url, topUrl);

        // If the data is already cached, return it.
        if (cachedData) {
            // Fire off a new request to update the cache in the background.
            this.lookupNative(url, topUrl);

            return cachedData;
        }

        // If nothing found in the cache, send the request to the native
        // process and store the result in the cache.
        const data = await this.lookupNative(url, topUrl);

        return data;
    };

    /**
     * Applies the configuration to the web page.
     *
     * @param configuration Configuration to apply.
     */
    public applyConfiguration = async (tabId: number, frameId: number, configuration: Configuration) => {
        await this.backgroundScript.applyConfiguration(tabId, frameId, configuration);
    };
}

export const engine = new Engine();
