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

global.chrome = chrome;

export {};
