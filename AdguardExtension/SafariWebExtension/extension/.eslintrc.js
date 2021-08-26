module.exports = {
    extends: ['airbnb-typescript'],
    parserOptions: {
        project: 'tsconfig.json',
    },
    rules: {
        'indent': ['error', 4, { SwitchCase: 1 }],
        "react/jsx-indent": ["error", 4],
        "react/jsx-indent-props": ["error", 4],
        '@typescript-eslint/indent': ['error', 4],
        'import/prefer-default-export': 0,
        'import/no-extraneous-dependencies': 0,
        'arrow-body-style': 0,
        'react/require-default-props': 0,

        "import/extensions": [
            "error",
            "ignorePackages",
            {
                "js": "never",
                "jsx": "never",
                "ts": "never",
                "tsx": "never"
            }
        ]
    }
};
