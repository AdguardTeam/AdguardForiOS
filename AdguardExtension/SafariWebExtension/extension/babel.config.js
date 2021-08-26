module.exports = (api) => {
    api.cache(true);

    return {
        presets: [
            ['@babel/preset-env'],
            '@babel/react',
            '@babel/preset-typescript',
        ],
        plugins: [
            ['@babel/plugin-proposal-decorators', { legacy: true }],
            ['@babel/plugin-proposal-class-properties', { loose: true }],
            ['@babel/plugin-proposal-private-methods', { loose: true }],
            '@babel/plugin-transform-runtime',
        ],
    };
};
