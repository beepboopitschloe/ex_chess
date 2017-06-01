import { mapActions, mapGetters } from 'vuex'

export default {
  name: 'Lobby',

  created() {
    this.loadAvailableGames()
  },

  computed: {
    ...mapGetters(['loadingGames', 'currentGame', 'availableGames', 'networkError'])
  },

  methods: {
    loadAvailableGames() {
      this.listGamesByStatus('waiting')
    },

    startNewGame() {
      this.createGame()
        .then(({ id: gameId }) => this.$router.push({ name: 'play', params: { gameId }}))
    },

    renderGames(h) {
      if (this.loadingGames) {
        return this.renderLoading(h)
      }

      if (this.availableGames.length === 0) {
        return <p>no active games</p>
      }

      const list = this.availableGames.map(game => (
        <li>
          <router-link to={{name: 'play', params: { gameId: game.id }}}>
            game with {game.playerOne.username}
          </router-link>
        </li>
      ))

      return <ul>{list}</ul>
    },

    renderLoading(h) {
      return <span>loading...</span>
    },

    ...mapActions(['listGamesByStatus', 'createGame'])
  },

  render(h) {
    const games = this.renderGames(h)

    return (
      <div>
        <h3>open games</h3>

        {games}

        <div>
          <button onClick={this.startNewGame}>
            start a new game
          </button>
        </div>
      </div>
    )
  }
}
