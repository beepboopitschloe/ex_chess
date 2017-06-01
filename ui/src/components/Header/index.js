import { mapActions, mapGetters } from 'vuex'
import style from './style.css'

export default {
  name: 'Header',

  methods: {
    ...mapActions(['logout'])
  },

  computed: {
    ...mapGetters(['identity'])
  },

  render(h) {
    let userDetail
    if (this.identity) {
      const { username } = this.identity
      const logout = (
        <button class="link-button" onClick={this.logout}>
          log out
        </button>
      )

      userDetail = (
        <div class={style.userDetail}>
          logged in as {username} ({logout})
        </div>
      )
    }

    return (
      <div class={style.header}>
          <h1>
            <router-link to="/">
              <span class={style.appTitleWeak}>ex</span><span class={style.appTitleStrong}>chess</span>
            </router-link>
          </h1>
        {userDetail}
      </div>
    )
  }
}
