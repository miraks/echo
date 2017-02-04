/* eslint import/no-extraneous-dependencies: ["error", { "devDependencies": true }] */

const path = require('path')
const webpack = require('webpack')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const ScriptExtHtmlWebpackPlugin = require('script-ext-html-webpack-plugin')
const FaviconsWebpackPlugin = require('favicons-webpack-plugin')

const env = process.env.NODE_ENV
const isProduction = env === 'production'

let envPlugins = []

if (isProduction) {
  envPlugins = [
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin()
  ]
}

const config = {
  entry: {
    app: './frontend/index.js'
  },
  output: {
    path: path.resolve(__dirname, 'priv/static'),
    filename: isProduction ? '[name]-[hash].js' : '[name].js',
    publicPath: '/'
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        options: {
          presets: [
            [
              'env',
              {
                targets: {
                  browsers: isProduction ? ['last 2 versions'] : ['last 2 firefox versions', 'last 2 chrome versions']
                },
                useBuiltIns: true
              }
            ],
            'react'
          ],
          plugins: [
            'transform-class-properties',
            'transform-function-bind',
            [
              'transform-object-rest-spread',
              {
                useBuiltIns: true
              }
            ]
          ]
        }
      },
      {
        test: /\.s(a|c)ss$/,
        loader: ExtractTextPlugin.extract({
          fallbackLoader: 'style-loader',
          loader: [`css-loader${isProduction ? '?minimize' : ''}`, 'sass-loader']
        })
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx']
  },
  plugins: envPlugins.concat([
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)
    }),
    new ExtractTextPlugin(isProduction ? '[name]-[contenthash].css' : '[name].css'),
    new HtmlWebpackPlugin({
      title: 'MOEX Helper',
      inject: 'head',
      template: './frontend/index.html'
    }),
    new ScriptExtHtmlWebpackPlugin({
      defaultAttribute: 'async'
    }),
    new FaviconsWebpackPlugin({
      logo: path.resolve('./frontend/favicon.png'),
      icons: {
        favicons: true,
        android: false,
        appleIcon: false,
        appleStartup: false,
        firefox: false
      }
    })
  ]),
  performance: {
    hints: false
  }
}

if (!isProduction) {
  Object.assign(config, {
    devtool: 'eval-source-map',
    devServer: {
      contentBase: path.resolve(__dirname, 'priv/static'),
      publicPath: '/',
      compress: true,
      port: 9000,
      historyApiFallback: true,
      proxy: {
        '/api': 'http://localhost:4000'
      }
    }
  })
}

module.exports = config
