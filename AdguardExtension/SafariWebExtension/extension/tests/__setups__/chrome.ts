const chrome = require('sinon-chrome');

if (!chrome.runtime.id) {
    chrome.runtime.id = 'test';
}

declare global {
    namespace NodeJS {
        interface Global {
            chrome: any;
        }
    }
}

// @ts-ignore
global.chrome = chrome;

export {};
