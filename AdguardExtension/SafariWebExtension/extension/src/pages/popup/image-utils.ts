import axios from 'axios';

import { getDomain } from '../common/utils/url';
import { log } from '../common/log';

const FALLBACK_ICON_COLOR = '67b279';

const toDataUrl = async (url: string): Promise<string> => {
    const response = await axios(url, { responseType: 'blob' });
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onloadend = () => resolve(reader.result as string);
        reader.onerror = reject;
        reader.readAsDataURL(response.data);
    });
};

export const getFaviconDataUrl = async (url?: string): Promise<string | null> => {
    if (!url) {
        return null;
    }

    const domain = getDomain(url);

    if (!domain) {
        return null;
    }

    // eslint-disable-next-line max-len
    const ADGUARD_FAVICON_SERVICE_URL = `https://icons.adguard.org/icon?fallback_icon_color=${FALLBACK_ICON_COLOR}&domain=`;
    const favIconUrl = `${ADGUARD_FAVICON_SERVICE_URL}${domain}`;

    const TIMEOUT_MS = 1000;
    const timeoutPromise = new Promise((resolve) => {
        setTimeout(() => {
            resolve(null);
        }, TIMEOUT_MS);
    });

    // eslint-disable-next-line @typescript-eslint/no-shadow
    const toDataUrlPromise = async (favIconUrl: string): Promise<string | null> => {
        try {
            const result = await toDataUrl(favIconUrl);
            return result;
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
