import browser from 'webextension-polyfill';

/**
 * Function returns true when permissions for all sites were allowed, otherwise false
 * If non-existing websites allowed, then all sites were allowed
 */
const areAllSitesAllowed = (): Promise<boolean> => {
    const NON_EXISTING_DOMAINS = ['http://non-existing-domain.com/', 'https://another-non-existing-domain.com/'];
    return browser.permissions.contains({ origins: NON_EXISTING_DOMAINS });
};

export const permissions = {
    areAllSitesAllowed,
};
