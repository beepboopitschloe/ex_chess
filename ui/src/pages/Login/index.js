import { mapGetters } from 'vuex'
import { get } from 'lodash'
import style from './style.css'

export default {
  created() {
    this.checkAuth()
  },

  data() {
    return {
      username: '',
      password: '',
      confirmPassword: '',
      validationError: null,
      loginOrSignup: 'login'
    }
  },

  methods: {
    setUsername(evt) {
      this.username = evt.target.value
    },

    setPassword(evt) {
      this.password = evt.target.value
    },

    setConfirmPassword(evt) {
      this.confirmPassword = evt.target.value
    },

    setValidationError(err) {
      this.validationError = err
    },

    checkAuth() {
      if (this.authorized) {
        this.$router.push('/')
      }
    },

    doLogin() {
      const { username, password } = this
      this.setValidationError(null)
      this.$store.dispatch('login', { username, password })
        .then(() => this.checkAuth())
    },

    doSignup() {
      const { username, password, confirmPassword } = this

      this.setValidationError(null)

      if (password.length < 8) {
        this.setValidationError('Password must be at least 8 characters.')
        return
      } else if (password !== confirmPassword) {
        this.setValidationError('Passwords do not match.')
        return
      }

      return this.$store.dispatch('signup', { username, password })
        .then(() => this.checkAuth())
    },

    toggleLoginOrSignup() {
      if (this.loginOrSignup === 'login') {
        this.loginOrSignup = 'signup'
      } else {
        this.loginOrSignup = 'login'
      }
    },

    renderError(h, error) {
      let errorText = 'An unknown error occurred.'

      if (typeof error === 'string') {
        errorText = error
      } else {
        const status = get(error, 'response.status')

        switch(status) {
          case 401:
            errorText = 'Invalid credentials. check your password and try again.'
            break
          case 422:
            errorText = 'Username is taken. Please try a different username.'
            break
        }
      }

      return (
        <div class={style.errorContainer}>
          <p>{errorText}</p>
        </div>
      )
    },

    renderSignup(h) {
      return (
        <div class={style.formContainer}>
          <div class={style.inputContainer}>
            <label>
              username
              <input type="text"
                    class={style.input}
                    placeholder="steve.jobs"
                    onInput={this.setUsername}
                    value={this.username}/>
            </label>
          </div>
          <div class={style.inputContainer}>
            <label>
              password
              <input type="password"
                    class={style.input}
                    onInput={this.setPassword}
                    value={this.password}/>
            </label>
          </div>
          <div class={style.inputContainer}>
            <label>
              confirm password
              <input type="password"
                    class={style.input}
                    onInput={this.setConfirmPassword}
                    value={this.confirmPassword}/>
            </label>
          </div>
          <button class={style.loginButton}
                  onClick={this.doSignup}>
            submit
          </button>
        </div>
      )
    },

    renderLogin(h) {
      return (
        <div class={style.formContainer}>
          <div class={style.inputContainer}>
            <label>
              username
              <input type="text"
                    class={style.input}
                    placeholder="steve.jobs"
                    onInput={this.setUsername}
                    value={this.username}/>
            </label>
          </div>
          <div class={style.inputContainer}>
            <label>
              password
              <input type="password"
                    class={style.input}
                    onInput={this.setPassword}
                    value={this.password}/>
            </label>
          </div>
          <button class={style.loginButton}
                  onClick={this.doLogin}>
            submit
          </button>
        </div>
      )
    }
  },

  computed: {
    ...mapGetters(['authorized', 'networkError'])
  },

  render(h) {
    const title = this.loginOrSignup === 'login' ? 'log in' : 'sign up'
    const switchBtn = this.loginOrSignup === 'login' ? 'sign up' : 'log in'
    const form = this.loginOrSignup === 'login' ? this.renderLogin(h) : this.renderSignup(h)

    const error = (this.validationError || this.networkError)
                ? this.renderError(h, this.validationError || this.networkError)
                : null

    return (
      <div class={style.page}>
        <h2 class={style.title}>{title}</h2>
        {error}
        {form}
        <div>
          <button class={style.linkButton}
                  onClick={this.toggleLoginOrSignup}>
            {switchBtn}
          </button>
        </div>
      </div>
    )
  }
}
