/* eslint-disable */
import { storage } from '../storage';
import { APPEARANCE_THEME_DEFAULT, AppearanceTheme } from '../../common/constants';
import { ActionLinks, NativeHostInterface } from './NativeHost';

const sleep = (timeout: number) => {
    return new Promise((resolve) => {
        setTimeout(resolve, timeout);
    });
};

interface State {
    appearanceTheme: AppearanceTheme,
    protectionEnabled: boolean,
    premiumApp: boolean,
    contentBlockersEnabled: boolean,
}

class NativeHostMock implements NativeHostInterface {
    STATE_KEY = 'state';

    DEFAULT_STATE: State = {
        appearanceTheme: APPEARANCE_THEME_DEFAULT,
        protectionEnabled: true,
        premiumApp: false,
        contentBlockersEnabled: true,
    };

    links?: ActionLinks;

    getState = async (): Promise<State> => {
        const currentState = await storage.get(this.STATE_KEY) as State;
        return currentState || this.DEFAULT_STATE;
    };

    setState = async (key: string, value: unknown) => {
        const prevState = await this.getState();
        const newState = { ...prevState, [key]: value };
        console.log('new state:', newState);
        await storage.set('state', newState);
    };

    withSleep = async (result?: any) => {
        await sleep(1000);
        return result;
    };

    isProtectionEnabled = async (url: string): Promise<boolean> => {
        console.log('isProtectionEnabled', url);
        const currentState = await this.getState();
        return this.withSleep(currentState.protectionEnabled);
    };

    enableProtection = async (): Promise<void> => {
        console.log('enableProtection');
        await this.setState('protectionEnabled', true);
        return this.withSleep();
    };

    disableProtection = async (): Promise<void> => {
        console.log('disableProtection');
        await this.setState('protectionEnabled', false);
        return this.withSleep();
    };

    hasUserRulesBySite = async (url: string) => {
        console.log('hasUserRulesBySite', url);
        return this.withSleep(true);
    };

    removeUserRulesBySite = async (url: string) => {
        console.log('removeUserRulesBySite', url);
        return this.withSleep();
    };

    isPremium = async () => {
        console.log('isPremium');
        const state = await this.getState();
        return this.withSleep(state.premiumApp);
    };

     togglePremium = async () => {
        const state = await this.getState();
        await this.setState('premiumApp', !state.premiumApp);
    };

    areContentBlockersEnabled = async () => {
        console.log('areContentBlockersEnabled');
        const state = await this.getState();
        return this.withSleep(state.contentBlockersEnabled);
    };

    toggleContentBlockersState = async () => {
        const key = 'contentBlockersEnabled';
        const state = await this.getState();
        await this.setState(key, !state[key]);
    };

    getAppearanceTheme = async () => {
        const state = await this.getState();
        return this.withSleep(state.appearanceTheme);
    };

    setAppearanceTheme = async (value: AppearanceTheme) => {
        await this.setState('appearanceTheme', value);
    };

    getAdvancedRulesText = async () => {
        const rulesText = `
example.org#$#h1 { color: pink }
example.org#%#//scriptlet('log', 'arg1', 'arg2')
`;
        return this.withSleep(rulesText);
    };

    setLinks(links: ActionLinks) {
        this.links = links;
    }

    getInitData(url: string) {
        return this.withSleep({
            appearanceTheme: 'light',
            contentBlockersEnabled: false,
            hasUserRules: true,
            premiumApp: false,
            protectionEnabled: false,
            addToBlocklistLink: '',
            addToAllowlistLink: '',
            removeAllBlocklistRulesLink: '',
            removeFromAllowlistLink: '',
        })
    }

    addToUserRules(ruleText: string): Promise<void> {
        throw new Error('Method not implemented.');
    }
    reportProblem(url: string): Promise<void> {
        throw new Error('Method not implemented.');
    }
    upgradeMe(): void {
        throw new Error('Method not implemented.');
    }
}

export const nativeHostMock = new NativeHostMock();
