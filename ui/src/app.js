import Vue from 'vue'
import { sync } from 'vuex-router-sync'
import App from './components/App'
import router from './router'
import store from './store'

sync(store, router)

if (process.env.NODE_ENV === 'production' && location.protocol !== 'https:') {
  // Netlify won't force SSL until we set up a custom domain, so this should work for now
  location.href = 'https:' + window.location.href.substring(window.location.protocol.length)
}

const app = new Vue({
  router,
  store,
  ...App
})

export { app, router, store }
