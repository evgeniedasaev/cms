"use strict";

import path from "path";
import webpack from "webpack";

const SERVER_SCHEMA = "http";
const SERVER_HOST = "cms"; 
const SERVER_PORT = 80;

const SERVER_URL = SERVER_SCHEMA + "://" + SERVER_HOST + ":" + SERVER_PORT + "/";

const ENV = process.env.NODE_ENV || "dev";
const isDev = ENV == "dev";

const DIST_DIR = path.resolve(__dirname, "../www/admin");
const SRC_DIR = path.resolve(__dirname, "client");

let config = {
    entry: ["babel-polyfill", SRC_DIR + "/index.js"],
    output: {
        path: DIST_DIR,
        filename: "js/main.js",
        publicPath: "/admin/"
    },
    watch: isDev,
    watchOptions: {
        aggregatedTimeout: 100
    },
    devtool: (isDev) ? "source-map" : null, 
    resolve: {
        extensions: [".js", ".jsx", ".css"]
    },
    module: {
        loaders: [
            {
                test: /.jsx?$/,
                loader: "babel-loader",
                query: {
                    presets: ["react", "es2015", "stage-2"]
                }
            },
            {
                test: /\.css$/,
                loaders: ["style-loader", "css-loader"]
            },
            {
                test: /\.(eot|svg|ttf|woff|woff2)$/,
                loader: "file-loader"
            },
            {
                test: /\.(jpg|png|gif)$/,
                loaders: [
                    "file-loader",
                    {
                        loader: "image-webpack-loader",
                        query: {
                            progressive: true,
                            optimizationLevel: 7,
                            interlaced: false,
                            pngquant: {
                                quality: "65-90",
                                speed: 4
                            }
                        }
                    }
                ]
            },
            {
                test: /\.html$/,
                loader: "html-loader"
            },
            {
                test: /\.json$/,
                loader: "json-loader"
            },
            {
                test: /\.(mp4|webm)$/,
                loader: "url-loader",
                query: {
                    limit: 10000
                }
            }
        ]
    },
    devServer: {
        hot: true,
        inline: true,
        contentBase: DIST_DIR,
        host: SERVER_HOST,
        port: 8080,
        proxy: {
            "**": {
                target: SERVER_URL,
                secure: false,
                changeOrigin: true
            }
        }
    }
};

if (ENV == "prod") {
    config.plugins.push(
        new webpack.optimize.UglifyJsPlugin({
            compress: {
                // don"t show unreachable variables etc
                warnings: false,
                drop_console: true,
                unsafe: true
            }
        })
    );
}

module.exports = config;