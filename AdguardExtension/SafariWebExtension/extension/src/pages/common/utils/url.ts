export const getCroppedDomain = (hostname: string) => {
    return hostname.startsWith('www.') ? hostname.substring(4) : hostname;
};

export const getDomain = (url: string) => {
    const { hostname } = new URL(url);
    return getCroppedDomain(hostname);
};
