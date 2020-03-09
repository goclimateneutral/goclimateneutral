module.exports = {
  corePlugins: {
    preflight: true
  },
  theme: {
    fontSize: {
      xs: '0.75rem',
      sm: '0.875rem',
      base: '1rem',
      lg: '1.125rem',
      xl: '1.25rem',
      '2xl': '1.5rem',
      '3xl': '1.875rem',
      '4xl': '2.25rem',
      '5xl': '3rem',
      '6xl': '4rem',
      'big-icon': '12rem'
    },
    inset: { // top/right/bottom/left
      0: 0,
      100: '100%',
      auto: 'auto'
    },
    maxHeight: {
      0: 0,
      full: '100%',
      screen: '100vh'
    },
    screens: {
      sm: '640px',
      md: '768px',
      lg: '1024px'
    }
  }
};
