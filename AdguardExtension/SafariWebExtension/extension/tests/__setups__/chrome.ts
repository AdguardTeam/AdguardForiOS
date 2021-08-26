const chrome = require('sinon-chrome');

if (!chrome.runtime.id) {
    chrome.runtime.id = 'test';
}

// @ts-ignore
global.chrome = chrome;
