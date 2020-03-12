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
        icon: '#bbd2bd'
      }
    },
    screens: {
      sm: '640px',
      md: '768px',
      lg: '1024px'
    }
  }
};
