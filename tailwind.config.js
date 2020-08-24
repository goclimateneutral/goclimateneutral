module.exports = {
  theme: {
    variants: {
      borderWidth: ['responsive', 'hover']
    },
    screens: {
      // Default: Mobile
      'm-lg': '640px', // Mobile Large
      t: '768px', // Tablet
      d: '1024px', // Desktop
      'd-md': '1280px', // Desktop Medium
      'd-lg': '1680px', // Desktop Large
      // below are temporary
      sm: '640px',
      md: '768px',
      lg: '1024px'
    },
    colors: {
      current: 'currentColor',
      transparent: 'transparent',
      black: '#000',
      white: '#fff',
      primary: '#1C4637',
      green: {
        dark: '#1C4637',
        'shade-1': '#317050',
        'shade-2': '#2E8731',
        accent: '#48A12A',
        'tint-2': '#90CF78',
        'tint-1': '#EBF6E6',
        pastel: '#F6FFF2'
      },
      yellow: {
        dark: '#453100',
        'shade-1': '#705207',
        'shade-2': '#D69C09',
        accent: '#FFC714',
        'tint-2': '#FFE286',
        'tint-1': '#FFF9E4',
        pastel: '#FFFCF3'
      },
      orange: {
        dark: '#4A1F10',
        'shade-1': '#994323',
        'shade-2': '#D15D32',
        accent: '#FF8153',
        'tint-2': '#FFAF91',
        'tint-1': '#FFF2ED',
        pastel: '#FFF8F5'
      },
      blue: {
        dark: '#142B4A',
        'shade-1': '#2A4A75',
        'shade-2': '#4673B3',
        accent: '#6F9BD9',
        'tint-2': '#A5C5F0',
        'tint-1': '#ECF3FC',
        pastel: '#F7FBFF'
      },
      gray: {
        dark: '#2A2928',
        'shade-1': '#4C4A48',
        'shade-2': '#878580',
        accent: '#C5C3BF',
        'tint-2': '#E0DFDC',
        'tint-1': '#F1F0EE',
        pastel: '#FAFAF9'
      },
      pink: {
        dark: '#481633',
        'shade-1': '#5B2946',
        'shade-2': '#9F527F',
        accent: '#D67EB2',
        'tint-2': '#E4A0C7',
        'tint-1': '#FCECF5',
        pastel: '#FFF7FC'
      },
      // below are temporary
      icon: '#bbd2bd',
      dark: '#444',
      bg: '#fff',
      secondary: '#f7f5e8',
      brand: '#f3f9f9',
      'alert-300': '#fcf8e3',
      'alert-600': '#faebcc',
      'alert-700': '#8a6d3b'
    },
    lineHeight: {
      none: '1',
      6: '1.5rem',
      8: '2rem',
      10: '2.5rem',
      12: '3rem',
      14: '3.5rem',
      20: '5rem'
    },
    fontWeight: {
      thin: '200',
      light: '300',
      normal: '400',
      medium: '500',
      semibold: '600',
      bold: '700',
      extrabold: '800',
      black: '900'
    },
    fontSize: (theme) => ({
      sm: ['0.8125rem', theme('lineHeight.6')],
      base: ['1rem', theme('lineHeight.6')],
      lg: ['1.25rem', theme('lineHeight.8')],
      xl: ['1.75rem', theme('lineHeight.8')],
      '2xl': ['2.25rem', theme('lineHeight.10')],
      '3xl': ['2.75rem', theme('lineHeight.12')],
      '4xl': ['3.25rem', theme('lineHeight.14')],
      '5xl': ['4.25rem', theme('lineHeight.20')],
      'big-icon': '12rem' // temporary
    }),
    fontFamily: false,
    borderRadius: {
      none: '0',
      default: '0.25rem',
      lg: '0.5rem',
      full: '9999px'
    },
    boxShadow: (theme) => ({
      default: '0 3px 10px -3px rgba(28, 70, 55, 0.2), 0 1px 3px 0px rgba(28, 70, 55, 0.1)',
      lg: '0 15px 30px -5px rgba(28, 70, 55, 0.1), 0 10px 10px -5px rgba(28, 70, 55, 0.05)',
      outline: `0 0 0 1px ${theme('colors.primary')}`,
      none: 'none'
    }),
    extend: {
      height: {
        96: '24rem',
        112: '28rem',
        160: '40rem',
        176: '44rem'
      },
      inset: { // top/right/bottom/left
        100: '100%',
        '1/2': '50%',
        '1/3': '33.333333%',
        '2/3': '66.666667%',
        '-1/2': '-50%'
      },
      width: {
        'max-content': 'max-content'
      },
      maxHeight: (theme) => ({
        0: 0,
        ...theme('spacing')
      }),
      minHeight: {
        '1/2-screen': '50vh'
      },
      maxWidth: {
        xs: '15rem',
        '1/4': '25%',
        '1/2': '50%',
        '3/4': '75%'
      },
      spacing: {
        96: '24rem',
        128: '32rem',
        '1/4': '25%',
        '1/2': '50%',
        '3/4': '75%',
        full: '100%'
      },
      zIndex: {
        '-10': '-10'
      },
      transitionProperty: {
        default: 'background-color, border-color, color, fill, stroke, opacity, box-shadow, transform, border-width, height, width, max-height, max-width',
        border: 'border-width',
        size: 'height, width, max-height, max-width'
      }
    }
  },
  plugins: []
};
