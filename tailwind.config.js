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
    }
  },  
  plugins: [require("daisyui")],

  daisyui: {
   themes: ["lemonade"],
  },
}
