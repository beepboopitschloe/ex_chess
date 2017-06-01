import Header from '../Header'
import style from './style.css'

export default {
  created() {
    this.$store.watch(
      state => this.$store.getters.authorized,
      this.checkAuth
    )

    this.checkAuth()
  },

  data() {
    return {
      waitingForAuth: true
    }
  },

  methods: {
    checkAuth() {
      this.$store.dispatch('loadAuthToken')
        .then(() => {
          this.waitingForAuth = false

          const authed = this.$store.getters.authorized

          if (!authed) {
            this.$router.push('/login')
          }
        })
    }
  },

  render(h) {
    let view = null

    if (!this.waitingForAuth) {
      view = (
        <div class={style.viewContainer}>
          <router-view></router-view>
        </div>
      )
    }

    return (
      <div id="app">
        <Header/>
        {view}
      </div>
    )
  }
}
