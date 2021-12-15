import { nativeHost } from './native-host';
import { nativeHostMock } from './native-host/nativeHostMock';

class AdGuard {
    mockNativeHost = true;

    get nativeHost() {
        if (this.mockNativeHost) {
            return nativeHostMock;
        }
        return nativeHost;
    }
}

export const adguard = new AdGuard();

declare global {
    namespace NodeJS {
        interface Global {
            adguard: AdGuard,
        }
    }
}

global.adguard = adguard;
