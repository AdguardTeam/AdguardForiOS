import { createContext } from 'react';
import browser from 'webextension-polyfill';
import {
    action,
    computed,
    configure,
    observable,
    runInAction,
    makeObservable,
} from 'mobx';

import { getDomain } from '../../common/utils/url';
import { translator } from '../../common/translators/translator';
import { messenger } from '../../common/messenger';
import { toDataUrl } from '../image-utils';
import { log } from '../../common/log';
import { AppearanceTheme } from '../../common/constants';

// Do not allow property change outside of store actions
configure({ enforceActions: 'observed' });

export enum PopupDataLoadingState {
    Idle = 'Idle',
    Loading = 'Loading',
    Done = 'Done',
}

enum SiteStatus {
    ProtectionStarting = 'ProtectionStarting',
    ProtectionEnabled = 'ProtectionEnabled',
    Allowlisted = 'Allowlisted',
    BasicOnly = 'BasicOnly',
}

const SiteStatusesMessages = {
    [SiteStatus.ProtectionStarting]: translator.getMessage('popup_action_current_site_desc_starting'),
    [SiteStatus.ProtectionEnabled]: translator.getMessage('popup_action_current_site_status_desc_enabled'),
    [SiteStatus.Allowlisted]: translator.getMessage('popup_action_current_site_desc_allowlisted'),
    [SiteStatus.BasicOnly]: translator.getMessage('popup_action_current_site_desc_basic_only'),
};

class PopupStore {
    @observable popupDataLoadingState = PopupDataLoadingState.Idle;

    @observable currentSiteStatus = SiteStatus.ProtectionEnabled;

    @observable currentSiteUrl?: string;

    @observable currentSiteFaviconDataUrl?: string;

    @observable permissionsModalViewed?: boolean;

    @observable allSitesAllowed?: boolean;

    @observable protectionEnabled: boolean = false;

    @observable hasUserRules: boolean = false;

    @observable upgradeModalVisible: boolean = false;

    @observable isFullscreen: boolean = false;

    @observable showProtectionDisabledModal: boolean = false;

    @observable contentBlockersEnabled: boolean = false;

    @observable appearanceTheme?: AppearanceTheme;

    /**
     * Flag variable
     * - true means that app is premium (user bought it),
     * - false means that app is free
     */
    @observable premiumApp: boolean = false;

    constructor() {
        makeObservable(this);
    }

    @action
    getPopupData = async () => {
        this.popupDataLoadingState = PopupDataLoadingState.Loading;

        const [currentTab] = await browser.tabs.query({
            active: true,
            currentWindow: true,
        });

        const popupData = await messenger.getPopupData(currentTab.url);

        const currentSiteFaviconDataUrl = await this.getFaviconDataUrl(currentTab.url);

        runInAction(() => {
            this.popupDataLoadingState = PopupDataLoadingState.Done;
            this.currentSiteUrl = currentTab.url;
            if (currentSiteFaviconDataUrl) {
                this.currentSiteFaviconDataUrl = currentSiteFaviconDataUrl;
            }
            this.permissionsModalViewed = popupData.permissionsModalViewed;
            this.allSitesAllowed = popupData.allSitesAllowed;
            this.protectionEnabled = popupData.protectionEnabled;
            this.hasUserRules = popupData.hasUserRules;
            this.premiumApp = popupData.premiumApp;
            this.contentBlockersEnabled = popupData.contentBlockersEnabled;
            this.showProtectionDisabledModal = !popupData.contentBlockersEnabled;
            this.appearanceTheme = popupData.appearanceTheme;
        });
    };

    getFaviconDataUrl = async (url?: string): Promise<string | null> => {
        if (!url) {
            return null;
        }

        let domain;
        try {
            domain = (new URL(url)).hostname;
        } catch (e) {
            return null;
        }

        if (!domain) {
            return null;
        }

        // TODO change to our proxy service when will be ready
        const duckDuckGoFavIconServiceUrl = 'https://icons.duckduckgo.com/ip3/';
        const favIconUrl = `${duckDuckGoFavIconServiceUrl}${domain}.ico`;

        const TIMEOUT_MS = 500;
        const timeoutPromise = new Promise((resolve) => {
            setTimeout(() => { resolve(null); }, TIMEOUT_MS);
        });

        // eslint-disable-next-line @typescript-eslint/no-shadow
        const toDataUrlPromise = async (favIconUrl: string): Promise<string | null> => {
            try {
                return await toDataUrl(favIconUrl);
            } catch (e) {
                log.error('Unable to get favicon data url', e);
                return null;
            }
        };

        return (await Promise.race([
            timeoutPromise,
            toDataUrlPromise(favIconUrl),
        ])) as Promise<string | null>;
    };

    @action
    setPermissionsModalViewed = async () => {
        await messenger.setPermissionsModalViewed();
        runInAction(() => {
            this.permissionsModalViewed = true;
        });
    };

    @computed
    get currentSiteDomain(): string {
        if (!this.currentSiteUrl) {
            return '';
        }

        return getDomain(this.currentSiteUrl);
    }

    @computed
    get currentSiteStatusMessage(): string {
        return SiteStatusesMessages[this.currentSiteStatus];
    }

    @action
    async toggleProtection() {
        if (!this.currentSiteUrl) {
            return;
        }

        const prevState = this.protectionEnabled;
        this.protectionEnabled = !this.protectionEnabled;
        try {
            await messenger.setProtectionStatus(this.protectionEnabled, this.currentSiteUrl);
        } catch (e) {
            runInAction(() => {
                this.protectionEnabled = prevState;
            });
        }
    }

    @action
    async deleteUserRules() {
        if (this.currentSiteUrl) {
            await messenger.deleteUserRules(this.currentSiteUrl);
        }
    }

    @action
    showUpgradeModal() {
        this.upgradeModalVisible = true;
    }

    @action
    closeUpgradeModal() {
        this.upgradeModalVisible = false;
    }

    @action
    setFullscreen(isFullscreen: boolean) {
        this.isFullscreen = isFullscreen;
    }

    @action
    setShowContentBlockersEnabledModal(state: boolean) {
        this.showProtectionDisabledModal = state;
    }
}

export const popupStoreValue = new PopupStore();
export const PopupStoreContext = createContext(popupStoreValue);
export const popupStore = PopupStoreContext;
