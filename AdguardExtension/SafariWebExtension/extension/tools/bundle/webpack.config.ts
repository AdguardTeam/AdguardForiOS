import path from 'path';
import { CleanWebpackPlugin } from 'clean-webpack-plugin';
import CopyWebpackPlugin from 'copy-webpack-plugin';
import HtmlWebpackPlugin from 'html-webpack-plugin';
import ForkTsCheckerWebpackPlugin from 'fork-ts-checker-webpack-plugin';
import UglifyJsPlugin from 'uglifyjs-webpack-plugin';

const BUILD_PATH = path.resolve(__dirname, '../../build');

const BACKGROUND_PATH = path.resolve(__dirname, '../../src/targets/background');
const CONTENT_PATH = path.resolve(__dirname, '../../src/targets/content');
const ASSISTANT_PATH = path.resolve(__dirname, '../../src/targets/assistant');
const POPUP_PATH = path.resolve(__dirname, '../../src/targets/popup');

export const config = {
    mode: 'production',
    devtool: 'inline-source-map',
    entry: {
        background: BACKGROUND_PATH,
        assistant: ASSISTANT_PATH,
        content: CONTENT_PATH,
        popup: POPUP_PATH,
    },
    output: {
        path: path.join(BUILD_PATH),
        filename: '[name].js',
    },
    resolve: {
        extensions: ['.ts', '.tsx', '.js'],
    },
    optimization: {
        minimizer: [
            new UglifyJsPlugin({
                cache: true,
            }),
        ],
    },
    module: {
        rules: [
            {
                test: /\.(ts|js)x?$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        babelrc: true,
                    },
                },
            },
            {
                test: /\.p?css$/i,
                use: ['style-loader', 'css-loader', 'postcss-loader'],
            },
        ],
    },
    plugins: [
        new ForkTsCheckerWebpackPlugin(),
        new CleanWebpackPlugin(),
        new HtmlWebpackPlugin({
            template: path.join(POPUP_PATH, 'index.html'),
            filename: 'popup.html',
            chunks: ['popup'],
            cache: false,
        }),
        new CopyWebpackPlugin({
            patterns: [
                {
                    context: 'src',
                    from: 'images',
                    to: 'images',
                },
                {
                    context: 'src',
                    from: '_locales',
                    to: '_locales',
                    /**
                     * Update extension name if extension is built for AdGuard Pro
                     * @param content
                     * @param absoluteFrom
                     */
                    transform: (content, absoluteFrom) => {
                        if (process.env.ADG_PRO !== '1') {
                            return content;
                        }

                        if (!absoluteFrom.endsWith('_locales/en/messages.json')) {
                            return content;
                        }

                        try {
                            const strings = JSON.parse(content.toString());
                            const nameString = strings?.extension_name?.message;
                            if (!nameString) {
                                return content;
                            }

                            strings.extension_name.message = `${nameString} Pro`;

                            return Buffer.from(JSON.stringify(strings, null, 4));
                        } catch (e) {
                            return content;
                        }
                    },
                },
                {
                    context: 'src',
                    from: 'manifest.json',
                    to: 'manifest.json',
                },
            ],
        }),
    ],
};
