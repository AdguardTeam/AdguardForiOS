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
import { messenger } from '../../common/messenger';
import { getFaviconDataUrl } from '../image-utils';
import { AppearanceTheme, Platforms } from '../../common/constants';
import { SiteStatus } from '../constants';

// Do not allow property change outside of store actions
configure({ enforceActions: 'observed' });

export enum PopupDataLoadingState {
    Idle = 'Idle',
    Loading = 'Loading',
    Done = 'Done',
}

export class PopupStore {
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

    @observable protectionModalVisible: boolean = false;

    @observable contentBlockersEnabled: boolean = false;

    @observable appearanceTheme?: AppearanceTheme;

    @observable advancedBlockingEnabled: boolean = false;

    @observable allowlistInverted: boolean = false;

    @observable advancedBlockingModalVisible: boolean = false;

    @observable platform: Platforms = Platforms.IPhone;

    @observable popupExpanded: boolean = false;

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

        const [popupData, currentSiteFaviconDataUrl] = await Promise.all([
            messenger.getPopupData(currentTab.url),
            getFaviconDataUrl(currentTab.url),
        ]);

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
            this.protectionModalVisible = !popupData.contentBlockersEnabled;
            this.appearanceTheme = popupData.appearanceTheme;
            this.advancedBlockingEnabled = popupData.advancedBlockingEnabled;
            this.allowlistInverted = popupData.allowlistInverted;
            this.platform = popupData.platform;
        });
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
    hideUpgradeModal() {
        this.upgradeModalVisible = false;
    }

    @action
    showAdvancedBlockingDisabledModal() {
        this.advancedBlockingModalVisible = true;
    }

    @action
    hideAdvancedBlockingModal() {
        this.advancedBlockingModalVisible = false;
    }

    @action
    setFullscreen(isFullscreen: boolean) {
        this.isFullscreen = isFullscreen;
    }

    @action
    setProtectionModalVisibleState(state: boolean) {
        this.protectionModalVisible = state;
    }

    @action
    togglePopupExpanded() {
        this.popupExpanded = !this.popupExpanded;
    }
}

export const popupStoreValue = new PopupStore();
export const PopupStoreContext = createContext(popupStoreValue);
export const popupStore = PopupStoreContext;
