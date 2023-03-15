import browser from 'webextension-polyfill';

export class Storage {
    get = async (key: string): Promise<unknown> => {
        try {
            const data = await browser.storage.local.get(key);
            return data[key];
        } catch (e) {
            throw new Error(`Error during storage access by path ${key}, e: ${e}`);
        }
    };

    set = async (key: string, data: unknown): Promise<void> => {
        try {
            await browser.storage.local.set({ [key]: data });
        } catch (e) {
            throw new Error(`Error during saving data to storage ${key}, e: ${e}`);
        }
    };
}
