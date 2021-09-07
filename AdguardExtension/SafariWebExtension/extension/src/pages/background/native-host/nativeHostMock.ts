/* eslint-disable */
import { storage } from '../storage';
import { APPEARANCE_THEME_DEFAULT, AppearanceTheme } from '../../common/constants';

const sleep = (timeout: number) => {
    return new Promise((resolve) => {
        setTimeout(resolve, timeout);
    });
};

export const nativeHostMock = (() => {
    const STATE_KEY = 'state';

    interface State {
        appearanceTheme: AppearanceTheme,
        protectionEnabled: boolean,
        premiumApp: boolean,
        contentBlockersEnabled: boolean,
    }

    const DEFAULT_STATE: State = {
        appearanceTheme: APPEARANCE_THEME_DEFAULT,
        protectionEnabled: true,
        premiumApp: false,
        contentBlockersEnabled: true,
    };

    const getState = async (): Promise<State> => {
        const currentState = await storage.get(STATE_KEY) as State;
        return currentState || DEFAULT_STATE;
    };

    const setState = async (key: string, value: unknown) => {
        const prevState = await getState();
        const newState = { ...prevState, [key]: value };
        console.log('new state:', newState);
        await storage.set('state', newState);
    };

    const withSleep = async (result?: any) => {
        await sleep(1000);
        return result;
    };

    const isProtectionEnabled = async (url: string): Promise<boolean> => {
        console.log('isProtectionEnabled', url);
        const currentState = await getState();
        return withSleep(currentState.protectionEnabled);
    };

    const enableProtection = async (): Promise<void> => {
        console.log('enableProtection');
        await setState('protectionEnabled', true);
        return withSleep();
    };

    const disableProtection = async (): Promise<void> => {
        console.log('disableProtection');
        await setState('protectionEnabled', false);
        return withSleep();
    };

    const hasUserRulesBySite = async (url: string) => {
        console.log('hasUserRulesBySite', url);
        return withSleep(true);
    };

    const removeUserRulesBySite = async (url: string) => {
        console.log('removeUserRulesBySite', url);
        return withSleep();
    };

    const isPremium = async () => {
        console.log('isPremium');
        const state = await getState();
        return withSleep(state.premiumApp);
    };

    const togglePremium = async () => {
        const state = await getState();
        await setState('premiumApp', !state.premiumApp);
    };

    const areContentBlockersEnabled = async () => {
        console.log('areContentBlockersEnabled');
        const state = await getState();
        return withSleep(state.contentBlockersEnabled);
    };

    const toggleContentBlockersState = async () => {
        const key = 'contentBlockersEnabled';
        const state = await getState();
        await setState(key, !state[key]);
    };

    const getAppearanceTheme = async () => {
        const state = await getState();
        return withSleep(state.appearanceTheme);
    };

    const setAppearanceTheme = async (value: AppearanceTheme) => {
        await setState('appearanceTheme', value);
    };

    const getAdvancedRulesText = async () => {
        // TODO on start get rules from native host
        const rulesText = `
example.org#$#h1 { color: pink }
example.org#%#//scriptlet('log', 'arg1', 'arg2')
`;
        return withSleep(rulesText);
    };

    return {
        isProtectionEnabled,
        enableProtection,
        disableProtection,
        hasUserRulesBySite,
        removeUserRulesBySite,
        isPremium,
        togglePremium,
        getState,
        toggleContentBlockersState,
        setAppearanceTheme,
        areContentBlockersEnabled,
        getAppearanceTheme,
        getAdvancedRulesText,
    };
})();

// TODO remove
// @ts-ignore
global.adguard = {
    nativeHostMock,
};
