import { createApp } from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify'
import { loadFonts } from './plugins/webfontloader'
import { apolloPlugin } from './plugins/apollo'

loadFonts()

createApp(App)
  .use(vuetify)
  .use(apolloPlugin)
  .mount('#app')
