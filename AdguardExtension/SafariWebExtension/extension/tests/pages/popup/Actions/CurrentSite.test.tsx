import React from 'react';
import userEvent from '@testing-library/user-event';
import {
    cleanup,
    getByRole,
    render,
    screen,
} from '../../../test-utils';

import { messenger } from '../../../../src/pages/common/messenger';
import { Popup } from '../../../../src/pages/popup/components/Popup';

jest.mock('webextension-polyfill', () => {
    return {
        ...global.chrome,
        tabs: {
            query: jest.fn(async () => { return [{ url: 'https://example.org' }]; }),
        },
    };
});

jest.mock('axios');
jest.mock('../../../../src/pages/common/translators/translator', () => {
    return {
        __esModule: true,
        translator: {
            getMessage: jest.fn((key) => key),
        },
    };
});
jest.mock('../../../../src/pages/popup/image-utils');

describe('current site action', () => {
    afterEach(() => {
        jest.clearAllMocks();
        cleanup();
    });

    describe('renders if app is free', () => {
        beforeEach(() => {
            jest.spyOn(messenger, 'getPopupData').mockResolvedValue({
                allSitesAllowed: true,
                permissionsModalViewed: true,
                protectionEnabled: true,
                hasUserRules: true,
                premiumApp: false,
                appearanceTheme: true,
                contentBlockersEnabled: true,
                advancedBlockingEnabled: true,
            });
        });

        it('renders basic protection description if app is free', async () => {
            render(<Popup />);

            const basicProtectionDesc = await screen.findByText('popup_action_current_site_desc_basic_only');
            expect(basicProtectionDesc).toBeInTheDocument();

            const actionParent = basicProtectionDesc.closest('div.action')! as HTMLElement;
            const button = getByRole(actionParent, 'button');
            expect(button).toBeInTheDocument();
        });

        it('opens upgrade modal', async () => {
            render(<Popup />);

            const basicProtectionDesc = await screen.findByText('popup_action_current_site_desc_basic_only');
            expect(basicProtectionDesc).toBeInTheDocument();

            const actionParent = basicProtectionDesc.closest('div.action')! as HTMLElement;
            const button = getByRole(actionParent, 'button');
            expect(button).toBeInTheDocument();

            userEvent.click(button);

            const upgradeModalTitle = await screen.findByText('popup_modal_title_free');
            expect(upgradeModalTitle).toBeInTheDocument();
        });
    });

    describe('renders if advanced blocking disabled', () => {
        beforeEach(() => {
            jest.spyOn(messenger, 'getPopupData').mockResolvedValue({
                allSitesAllowed: true,
                permissionsModalViewed: true,
                protectionEnabled: true,
                hasUserRules: true,
                premiumApp: true,
                appearanceTheme: true,
                contentBlockersEnabled: true,
                advancedBlockingEnabled: false,
            });
        });

        it('renders basic protection description if advanced blocking is disabled', async () => {
            render(<Popup />);

            const basicProtectionDesc = await screen.findByText('popup_action_current_site_desc_basic_only');
            expect(basicProtectionDesc).toBeInTheDocument();

            const actionParent = basicProtectionDesc.closest('div.action')! as HTMLElement;
            const button = getByRole(actionParent, 'button');
            expect(button).toBeInTheDocument();
        });

        it('opens enable advanced blocking modal', async () => {
            render(<Popup />);

            const basicProtectionDesc = await screen.findByText('popup_action_current_site_desc_basic_only');
            expect(basicProtectionDesc).toBeInTheDocument();

            const actionParent = basicProtectionDesc.closest('div.action')! as HTMLElement;
            const button = getByRole(actionParent, 'button');
            expect(button).toBeInTheDocument();

            userEvent.click(button);

            const advancedBlockingModalTitle = await screen.findByText('popup_modal_advanced_blocking_disabled_title');
            expect(advancedBlockingModalTitle).toBeInTheDocument();
        });
    });

    describe('renders inverted allowlist', () => {
        it('renders allowlist description', async () => {
            jest.spyOn(messenger, 'getPopupData').mockResolvedValue({
                allSitesAllowed: true,
                permissionsModalViewed: true,
                protectionEnabled: false,
                hasUserRules: true,
                premiumApp: true,
                appearanceTheme: true,
                contentBlockersEnabled: true,
                advancedBlockingEnabled: false,
                allowlistInverted: false,
            });

            render(<Popup />);

            const basicProtectionDesc = await screen.findByText('popup_action_current_site_desc_allowlisted');
            expect(basicProtectionDesc).toBeInTheDocument();
        });

        it('renders inverted allowlist description', async () => {
            jest.spyOn(messenger, 'getPopupData').mockResolvedValue({
                allSitesAllowed: true,
                permissionsModalViewed: true,
                protectionEnabled: false,
                hasUserRules: true,
                premiumApp: true,
                appearanceTheme: true,
                contentBlockersEnabled: true,
                advancedBlockingEnabled: false,
                allowlistInverted: true,
            });

            render(<Popup />);

            const basicProtectionDesc = await screen.findByText('popup_action_current_site_desc_allowlisted_inverted');
            expect(basicProtectionDesc).toBeInTheDocument();
        });
    });
});
