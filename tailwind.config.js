const plugin = require('tailwindcss/plugin');

module.exports = {
  theme: {
    extend: {
      fontSize: {
        'big-icon': '12rem'
      },
      inset: { // top/right/bottom/left
        100: '100%'
      },
      maxHeight: {
        0: 0
      },
      colors: {
        'alert-300': '#fcf8e3', // temporary bootstrap colours
        'alert-600': '#faebcc',
        'alert-700': '#8a6d3b',
        brand: '#f3f9f9',
        secondary: '#f7f5e8',
        bg: '#fff',
        dark: '#444',
        icon: '#bbd2bd',
        gray: {
          100: '#F9F9F9',
          200: '#EFEFEF',
          300: '#E5E5E6',
          400: '#D2D2D3',
          500: '#BFBFC0',
          600: '#ACACAD',
          700: '#737373',
          800: '#565656',
          900: '#39393A'
        },
        'bootstrap-green': {
          100: '#EFF8EF',
          200: '#D6EDD6',
          300: '#BEE3BE',
          400: '#8DCD8D',
          500: '#5CB85C',
          600: '#53A653',
          700: '#376E37',
          800: '#295329',
          900: '#1C371C'
        }
      }
    },
    screens: {
      sm: '640px',
      md: '768px',
      lg: '1024px'
    }
  },
  plugins: [
    plugin(({ addComponents }) => {
      const inputs = {
        '.input': {
          backgroundColor: '#fff',
          color: '#000',
          borderWidth: 1,
          borderRadius: '0.25rem',
          borderColor: '#D2D2D3',
          padding: '0.5rem'
        }
      };
      addComponents(inputs);
    })
  ]
};
