import React from 'react';
import { render, screen } from '@testing-library/react';

import { Popup } from '../../../src/pages/popup/components/Popup';
import { messenger } from '../../../src/pages/common/messenger';
import { PopupStoreContext, popupStoreValue } from '../../../src/pages/popup/stores/PopupStore';
import { DeleteUserRules } from '../../../src/pages/popup/components/Actions/DeleteUserRules';

jest.mock('webextension-polyfill', () => {
    return {
        ...global.chrome,
        tabs: {
            query: jest.fn(async () => { return [{ url: 'https://example.org' }]; }),
        },
    };
});

jest.mock('axios');
jest.mock('../../../src/pages/common/translators/translator', () => {
    return {
        __esModule: true,
        translator: {
            getMessage: jest.fn((key) => key),
        },
    };
});
jest.mock('../../../src/pages/popup/image-utils');

describe('popup screen', () => {
    it('renders delete all user rules action', async () => {
        jest.spyOn(messenger, 'getPopupData').mockResolvedValue({
            allSitesAllowed: true,
            permissionsModalViewed: true,
            protectionEnabled: true,
            hasUserRules: true,
            premiumApp: true,
            appearanceTheme: true,
            contentBlockersEnabled: true,
        });

        render(<Popup />);

        expect(await screen.findByText('popup_action_delete_user_rules')).toBeInTheDocument();
    });

    it('doesn\'t render delete all user rules action', async () => {
        jest.spyOn(messenger, 'getPopupData').mockResolvedValue({
            allSitesAllowed: true,
            permissionsModalViewed: true,
            protectionEnabled: true,
            hasUserRules: false,
            premiumApp: true,
            appearanceTheme: true,
            contentBlockersEnabled: true,
        });

        render(<Popup />);

        expect(await screen.findByText('popup_action_delete_user_rules')).not.toBeInTheDocument();
    });

    it('This is an example how to use react testing library with Context.Provider', async () => {
        popupStoreValue.hasUserRules = true;
        popupStoreValue.protectionEnabled = true;
        popupStoreValue.contentBlockersEnabled = true;

        // TODO find way to clone popupStoreValue and provide it required values

        render(
            <PopupStoreContext.Provider value={popupStoreValue}>
                <DeleteUserRules />
            </PopupStoreContext.Provider>,
        );

        expect(await screen.findByText('popup_action_delete_user_rules')).toBeInTheDocument();
    });
});
