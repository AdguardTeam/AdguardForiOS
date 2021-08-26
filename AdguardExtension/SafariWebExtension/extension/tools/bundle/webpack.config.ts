import path from 'path';
import { CleanWebpackPlugin } from 'clean-webpack-plugin';
import CopyWebpackPlugin from 'copy-webpack-plugin';
import HtmlWebpackPlugin from 'html-webpack-plugin';
import ForkTsCheckerWebpackPlugin from 'fork-ts-checker-webpack-plugin';

const BUILD_PATH = path.resolve(__dirname, '../../build');

const BACKGROUND_PATH = path.resolve(__dirname, '../../src/targets/background');
const CONTENT_PATH = path.resolve(__dirname, '../../src/targets/content');
const ASSISTANT_PATH = path.resolve(__dirname, '../../src/targets/assistant');
const POPUP_PATH = path.resolve(__dirname, '../../src/targets/popup');

export const config = {
    mode: 'development',
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
