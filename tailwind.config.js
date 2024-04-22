module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        main: ["Kiwi Maru", "Kosugi Maru", "sans-serif"]
      }
    },
    screens: {
      sm: '300px',
      md: '669px',
      lg: '1024px',
      xl: '1280px'
    },
  },  

  plugins: [require("daisyui")],

  daisyui: {
   themes: ["lemonade"],
  },
}
