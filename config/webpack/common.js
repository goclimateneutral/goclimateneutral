const path = require('path');
const glob = require('glob');
const fs = require('fs');
const yaml = require('js-yaml');
const webpack = require('webpack');
const WebpackAssetsManifest = require('webpack-assets-manifest');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

const env = process.env.NODE_ENV || 'development';
const sharedConfig = yaml.safeLoad(fs.readFileSync('config/webpack.yml'))[env];
const inDevServer = process.argv.find(v => v.includes('webpack-dev-server'));

function buildNamedEntryPoints(paths) {
  const entryPoints = {};
  paths.forEach(entryPath => entryPoints[path.basename(entryPath, '.js')] = entryPath)
  return entryPoints;
}

const cssLoaders = [
  /* Using style-loader when running dev server allows hot updating when running with HMR */
  (inDevServer ? { loader: 'style-loader' } : MiniCssExtractPlugin.loader),
  {
    loader: 'css-loader',
    options: {
      sourceMap: true
    }
  },
  {
    loader: 'postcss-loader',
    options: {
      ident: 'postcss'
    },
  },
];

module.exports = {
  entry: buildNamedEntryPoints(glob.sync('./app/assets/bundles/*.js')),
  output: {
    path: path.resolve(`./public/${sharedConfig.output_path}`),
    publicPath: `/${sharedConfig.output_path}/`,
    filename: '[name]-[contenthash].js',
    devtoolModuleFilenameTemplate: info => `${info.resource.replace('./', '').replace(/\/(?=.*\/)/g, '__').replace('.', `-${info.hash}.`)}`
  },
  plugins: [
    new WebpackAssetsManifest({
      integrity: false,
      entrypoints: true,
      writeToDisk: true
    }),
    new MiniCssExtractPlugin({
      filename: '[name]-[contenthash].css'
    }),
    /* Bootstrap 3 does not import jQuery. This should not be needed once we move to Bootstrap 4. */
    new webpack.ProvidePlugin({
      jQuery: 'jquery'
    })
  ],
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel-loader"
      },
      {
        test: /\.css$/,
        use: cssLoaders
      },
      {
        test: /\.scss$/,
        use: [
          ...cssLoaders,
          {
            loader: 'sass-loader',
            options: {
              implementation: require("sass"),
              sourceMap: true
            }
          }
        ]
      },
      {
        test: /\.(png|svg|jpg|gif|ico|mp4|ttf|woff|woff2|eot)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[path][name]-[contenthash].[ext]',
              context: path.join('app', 'assets'),
            }
          }
        ]
      }
    ]
  },
  optimization: {
    splitChunks: {
      chunks: 'all',
      name: false
    },
    moduleIds: 'hashed'
  },
  devtool: 'source-map'
};
