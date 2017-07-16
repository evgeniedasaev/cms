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
        extensions: [".js", ".jsx"]
    },
    module: {
        loaders: [
            {
                test: /.jsx?$/,
                include: SRC_DIR,
                loader: "babel-loader",
                query: {
                    presets: ["react", "es2015", "stage-2"]
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