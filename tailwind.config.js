module.exports = {
  corePlugins: {
    preflight: true
  },
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
        'alert-700': '#8a6d3b'
      }
    },
    screens: {
      sm: '640px',
      md: '768px',
      lg: '1024px'
    }
  }
};
