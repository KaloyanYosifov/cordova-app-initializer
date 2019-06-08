/**
 * The external dependencies.
 */
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const Dotenv = require('dotenv-webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin')

/**
 * Export the configuration.
 *
 * @type {Object}
 */
module.exports = {
    /**
     * The base directory for resolving entry points.
     */
    context: path.resolve(__dirname, '../app'),

    /**
     * The point at which the application starts executing.
     */
    entry: [
        './js/main.js',
        './css/main.scss'
    ],

    /**
     * Instruct webpack how and where it should output the bundles.
     */
    output: {
        /**
         * The name of the output bundle.
         */
        filename: 'js/bundle.js',

        /**
         * The path that will contain the bundles.
         */
        path: path.resolve(__dirname, '../www')
    },

    /**
     * Instruct webpack how to treat different types of modules.
     */
    module: {
        /**
         * Define the rules used to manipulate the modules.
         */
        rules: [
            /**
             * Enable ES201* syntax in JavaScript files.
             */
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: [
                    {
                        loader: 'babel-loader',
                        options: {
                            cacheDirectory: true
                        }
                    }
                ]
            },

            /**
             * Enable CSS syntax.
             */
            {
                test: /\.css$/,
                use: [
                    {
                        loader: MiniCssExtractPlugin.loader,
                        options: {
                            publicPath: '../',
                        }
                    },
                    {
                        loader: 'css-loader',
                        options: {
                            imports: false,
                            importLoaders: 1
                        }
                    },
                    {
                        loader: 'postcss-loader'
                    },
                ]
            },

            /**
             * Parse SCSS
             */

            {
                test: /\.scss$/,
                use: [
                    {
                        loader: MiniCssExtractPlugin.loader,
                        options: {
                            publicPath: '../',
                        }
                    },
                    {
                        loader: 'css-loader',
                        options: {
                            imports: false,
                            importLoaders: 1
                        }
                    },
                    {
                        loader: 'sass-loader'
                    }
                ]
            },

            /**
             * Copy the fonts.
             */
            {
                test: /\.(woff2?|ttf|eot|svg)$/,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            name: '[name].[ext]',
                            outputPath: 'static/fonts/',
                            publicPath: '../static/fonts/'
                        }
                    }
                ]
            },

            /**
             * Copy the images.
             */
            {
                test: /\.(jpe?g|png|gif)$/,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            name: '[name].[ext]',
                            outputPath: 'static/images/',
                            publicPath: '../static/images/'
                        }
                    }
                ]
            }
        ]
    },

    /**
     * Configure how modules are resolved.
     */
    resolve: {
        /**
         * Create aliases to import the components easier.
         */
        modules: [
            'app/js',
            'node_modules',
        ],

        /**
         * Automattically resolve certain extensions.
         */
        extensions: [
            '*',
            '.js',
            '.json',
            '.vue'
        ],

        /**
         * Create aliases to import certain modules more easily.
         */
        alias: {
            'assets': path.resolve(__dirname, '../app/assets'),
            '@': path.resolve(__dirname, '../app/js'),
        }
    },

    /**
     * Customize the build process.
     */
    plugins: [
        /**
         * Generate the HTML file.
         */
        new HtmlWebpackPlugin({
            template: 'index.html',
            inject: false
        }),

        /**
         * Generate the CSS file.
         */
        new MiniCssExtractPlugin({
            // Options similar to the same options in webpackOptions.output
            // both options are optional
            filename: 'css/bundle.css',
        }),

        new Dotenv({
            path: './.env'
        }),

        new CopyWebpackPlugin([
            {
                from: '../app/static/images/',
                to: '../www/static/images/',
                toType: 'dir'
            },
        ])
    ]
};
