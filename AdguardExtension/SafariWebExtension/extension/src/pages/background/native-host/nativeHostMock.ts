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
    hasUserRules: boolean,
    advancedBlockingEnabled: boolean,
}

class NativeHostMock implements NativeHostInterface {
    STATE_KEY = 'state';

    DEFAULT_STATE: State = {
        appearanceTheme: APPEARANCE_THEME_DEFAULT,
        protectionEnabled: true,
        premiumApp: true,
        contentBlockersEnabled: true,
        hasUserRules: true,
        advancedBlockingEnabled: false,
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
!
! Title: Rules for extended css rules test
!
! Filter to be used for testing purposes
! https://testcases.adguard.com
!
! Hide warning
testcases.adguard.com,surge.sh###subscribe-to-test-extended-css-rules-filter
!
testcases.adguard.com,surge.sh#?##case1.banner:has(a.banner-link)
testcases.adguard.com,surge.sh#?##case2.banner:contains(Click Me!)
testcases.adguard.com,surge.sh#?##case3.banner:matches-css(opacity: 0.9)
testcases.adguard.com,surge.sh#?##case4.banner:matches-css-after(content: sponsored)
testcases.adguard.com,surge.sh#?##case5.banner:matches-css-before(content: sponsored)
testcases.adguard.com,surge.sh#?##case6.banner:has-text(You would want to click me for sure!)
testcases.adguard.com,surge.sh#?##case7.banner:-abp-has(a.banner-link)
testcases.adguard.com,surge.sh#?##case8.banner:contains(Click Me!)
testcases.adguard.com,surge.sh#?##case9.banner:contains(/[aа]{20,}/)
testcases.adguard.com,surge.sh#?##case10.banner:matches-css(background-image: /url\\(data\\:image\\/svg\\+xml;base64,[A-Za-z0-9]{100,}/)
testcases.adguard.com,surge.sh#?##case11.banner:matches-css-after(background-image: /url\\(data\\:image\\/svg\\+xml;base64,[A-Za-z0-9]{100,}/)
testcases.adguard.com,surge.sh#?##case12.banner:matches-css-before(background-image: /url\\(data\\:image\\/svg\\+xml;base64,[A-Za-z0-9]{100,}/)
testcases.adguard.com,surge.sh#?#body #case13.banner[-ext-has="a.banner-link"]
testcases.adguard.com,surge.sh#?#.container > #case14.banner[-ext-contains="/[aа]{20,}/"]
testcases.adguard.com,surge.sh#?##case14 + #case15.banner[-ext-matches-css-after="content:sponsored"]
testcases.adguard.com,surge.sh#?##case1 ~ #case16.banner[-ext-matches-css-before="content:sponsored"]
testcases.adguard.com,surge.sh#?#*:contains(/absolute[\\s\\S]*-\\d{4}/) + * > .banner:contains(/а/) ~ #case17.banner:has(> div:contains(/а/):nth-child(100n + 2))
testcases.adguard.com,surge.sh#?#.test-xpath-case18:xpath(//*[@class="test-case18-div"]/../..)
testcases.adguard.com,surge.sh#?#.test-nth-ancestor-case19:nth-ancestor(3)
testcases.adguard.com,surge.sh#?#.test-upward-selector:upward(#case20)
testcases.adguard.com,surge.sh#?#.test-upward-number-case21:upward(4)
! Case 22
testcases.adguard.com,surge.sh#?##inframe1:has(.content)
!
testcases.adguard.com,surge.sh#?##case23 > div:contains(/kick me!|\\(18\\+\\)|https:\\/\\/vk.cc|testTEXT|vk.com\\/test_id/)
testcases.adguard.com,surge.sh#?##case24 > div:matches-attr("/^data-.{4}$/"="/banner/")
testcases.adguard.com,surge.sh#?##case25 > div:matches-property("id"="/property-match/")
testcases.adguard.com,surge.sh#?##case26:remove()
testcases.adguard.com,surge.sh#$?##case27:has(div) { remove: true; }
testcases.adguard.com,surge.sh#?##case28 > :is(.case28, #main, footer, span):contains(isTest)
        `;
        return this.withSleep(rulesText);
    };

    setLinks(links: ActionLinks) {
        this.links = links;
    }

    async getInitData(url: string) {
        const state = await this.getState();
        return this.withSleep({
            appearanceTheme: state.appearanceTheme,
            contentBlockersEnabled: state.contentBlockersEnabled,
            hasUserRules: state.hasUserRules,
            premiumApp: state.premiumApp,
            protectionEnabled: state.protectionEnabled,
            advancedBlockingEnabled: state.advancedBlockingEnabled,
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
    upgradeMe(): Promise<void> {
        throw new Error('Method not implemented.');
    }
    turnOnAdvancedBlocking(): Promise<void> {
        throw new Error('Method not implemented.');
    }
}

export const nativeHostMock = new NativeHostMock();
