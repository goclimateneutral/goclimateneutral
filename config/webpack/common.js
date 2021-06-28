const path = require('path');
const glob = require('glob');
const fs = require('fs');
const yaml = require('js-yaml');
const WebpackAssetsManifest = require('webpack-assets-manifest');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

const env = process.env.NODE_ENV || 'development';
const sharedConfig = yaml.safeLoad(fs.readFileSync('config/webpack.yml'))[env];
const inDevServer = process.argv.find((v) => v.includes('webpack-dev-server'));

function buildNamedEntryPoints(paths) {
  const entryPoints = {};
  paths.forEach((entryPath) => { entryPoints[path.basename(entryPath, '.js')] = entryPath; });
  return entryPoints;
}

module.exports = {
  entry: buildNamedEntryPoints(glob.sync('./app/assets/bundles/*.js')),
  output: {
    path: path.resolve(`./public/${sharedConfig.output_path}`),
    publicPath: `/${sharedConfig.output_path}/`,
    filename: '[name]-[contenthash].js',
    devtoolModuleFilenameTemplate: (info) => `${info.resource.replace('./', '').replace(/\/(?=.*\/)/g, '__').replace('.', `-${info.hash}.`)}`
  },
  plugins: [
    new WebpackAssetsManifest({
      integrity: false,
      entrypoints: true,
      writeToDisk: true
    }),
    new MiniCssExtractPlugin({
      filename: '[name]-[contenthash].css'
    })
  ],
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      },
      {
        test: /\.css$/,
        use: [
          /* Using style-loader when running dev server allows hot updating when running with HMR */
          (inDevServer ? { loader: 'style-loader' } : MiniCssExtractPlugin.loader),
          {
            loader: 'css-loader',
            options: {
              sourceMap: true
            }
          },
          {
            loader: 'postcss-loader'
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
              context: path.join('app', 'assets')
            }
          }
        ]
      }
    ]
  },
  optimization: {
    splitChunks: {
      cacheGroups: {
        modules: {
          test: /[\\/]node_modules[\\/](?!bootstrap)/,
          name: 'modules',
          // Currently undocumented feature:  https://github.com/webpack/webpack/pull/6791
          chunks: (chunk) => chunk.name.match(/^main$/)
        }
      },
      name: false
    },
    moduleIds: 'hashed'
  },
  devtool: 'source-map',
  resolve: {
    alias: {
      ReactComponents: path.resolve(__dirname, '/app/assets/main/react_components')
    }
  }
};
