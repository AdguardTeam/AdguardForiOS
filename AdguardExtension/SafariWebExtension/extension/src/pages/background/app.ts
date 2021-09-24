/* eslint-disable class-methods-use-this */
import browser from 'webextension-polyfill';

import { storage } from './storage';

class App {
    PERMISSIONS_MODAL_VIEWED = 'permissions_modal_viewed';

    // TODO extract all storage keys in common scheme
    public isPermissionsModalViewed = async (): Promise<boolean> => {
        const permissionsModalViewed = await storage.get(this.PERMISSIONS_MODAL_VIEWED);
        return !!permissionsModalViewed;
    };

    public setPermissionsModalViewed = async () => {
        await storage.set(this.PERMISSIONS_MODAL_VIEWED, true);
    };

    get manifest() {
        return browser.runtime.getManifest();
    }

    get version() {
        return this.manifest.version;
    }
}

export const app = new App();
