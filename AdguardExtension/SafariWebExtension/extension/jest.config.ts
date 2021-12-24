module.exports = {
    verbose: true,
    testEnvironment: 'jsdom',
    setupFiles: ['./tests/__setups__/chrome.ts'],
    setupFilesAfterEnv: ['<rootDir>/tests/__setups__/jest-setup.ts'],
    moduleNameMapper: {
        '\\.(jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$': '<rootDir>/tests/__mocks__/fileMock.ts',
        '\\.(css|less|pcss)$': '<rootDir>/tests/__mocks__/styleMock.ts',
    },
};
