const tailwindcss = require('tailwindcss');
const purgecss = require('@fullhuman/postcss-purgecss');

const environment = {
  plugins: [
    tailwindcss
  ]
};

/**
 * Custom PurgeCSS Extractor
 * https://github.com/FullHuman/purgecss
 * https://github.com/FullHuman/purgecss-webpack-plugin
 * https://gist.github.com/josephan/45569c48ee4867237e89417aed283103#gistcomment-3152652
 */

// Only run PurgeCSS in production (you can also add staging here)
if (process.env.RAILS_ENV === 'production') {
  environment.plugins.push(
    purgecss({
      content: ['./app/views/**/*.html.erb', './app/controllers/**/*.rb', './app/assets/javascripts/**/*.js'],
      css: ['./app/assets/stylesheets'],
      extractors: [
        {
          extractor: (content) => content.match(/[A-Za-z0-9-_:/]+/g) || [],
          extensions: ['html.erb', 'js']
        }
      ]
    })
  );
}

module.exports = environment;
