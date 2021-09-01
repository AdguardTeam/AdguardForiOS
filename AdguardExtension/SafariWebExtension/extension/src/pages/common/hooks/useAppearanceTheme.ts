import throttle from 'lodash/throttle';
import { useLayoutEffect } from 'react';

import { APPEARANCE_THEME_DEFAULT, AppearanceTheme } from '../constants';

export const useAppearanceTheme = (appearanceTheme?: AppearanceTheme) => {
    useLayoutEffect(() => {
        const STORAGE_KEY = 'appearance_theme';
        const DARK_THEME_CLASS = 'dark-mode';
        const LIGHT_THEME_CLASS = 'light-mode';
        const SET_TO_STORAGE_TIMEOUT = 500;

        const throttledSetToStorage = throttle((mode) => {
            localStorage.setItem(STORAGE_KEY, mode);
        }, SET_TO_STORAGE_TIMEOUT);

        let theme = appearanceTheme;

        if (!theme) {
            const storedTheme = localStorage.getItem(STORAGE_KEY);

            if (storedTheme
                && Object.values(AppearanceTheme).includes(storedTheme as AppearanceTheme)) {
                theme = storedTheme as AppearanceTheme;
            } else {
                theme = APPEARANCE_THEME_DEFAULT;
            }
        } else {
            throttledSetToStorage(theme);
        }

        switch (theme) {
            case AppearanceTheme.Dark: {
                document.documentElement.classList.add(DARK_THEME_CLASS);
                document.documentElement.classList.remove(LIGHT_THEME_CLASS);
                break;
            }
            case AppearanceTheme.Light: {
                document.documentElement.classList.add(LIGHT_THEME_CLASS);
                document.documentElement.classList.remove(DARK_THEME_CLASS);
                break;
            }
            case AppearanceTheme.System: {
                document.documentElement.classList.remove(DARK_THEME_CLASS);
                document.documentElement.classList.remove(LIGHT_THEME_CLASS);
                break;
            }
            default:
                throw new Error(`Impossible theme value: ${theme}`);
        }
    }, [appearanceTheme]);
};
