import { mapActions, mapGetters } from 'vuex'
import style from './style.css'

export default {
  name: 'Play',

  created() {
    this.loadGameFromParams()
  },

  data() {
    return {
      pendingMove: ''
    }
  },

  methods: {
    setPendingMove(evt) {
      this.pendingMove = evt.target.value
    },

    sendPendingMove() {
      this.sendMove(this.pendingMove)
    },

    loadGameFromParams() {
      const gameId = this.$route.params.gameId

      if (this.currentGame && this.currentGame.id === gameId) {
        return this.joinGame(this.currentGame)
      }

      return this.joinGameById(gameId)
    },

    ...mapActions(['loadGame', 'joinGame', 'joinGameById', 'sendMove'])
  },

  computed: {
    userIsPlaying() {
      if (!this.currentGame || this.currentGame.status !== 'playing') {
        return false
      }

      const { playerOne, playerTwo } = this.currentGame
      const { id } = this.identity

      return id === playerOne.id || id === playerTwo.id
    },

    opponent() {
      if (!this.currentGame || this.currentGame.status !== 'playing') {
        return null
      }

      const { playerOne, playerTwo } = this.currentGame

      if (this.identity.id === playerOne.id) {
        return playerTwo
      } else {
        return playerOne
      }
    },

    activePlayer() {
      if (!this.currentGame || this.currentGame.status !== 'playing') {
        return null
      }

      const { playerOne, playerTwo, playerOneTurn } = this.currentGame

      return playerOneTurn ? playerOne : playerTwo
    },

    isMyTurn() {
      const p = this.activePlayer
      return p && p.id === this.identity.id
    },

    ...mapGetters(['currentGame', 'identity'])
  },

  render(h) {
    if (!this.currentGame) {
      return <p>loading...</p>
    }

    const { status } = this.currentGame

    if (status === 'waiting' || !this.opponent) {
      return <p>waiting for opponent...</p>
    }

    return (
      <div>
        <h3>playing against {this.opponent.username}</h3>
        <h4>moves:</h4>
        {renderMoves(h, this.currentGame)}
        {renderMoveInput(h, this)}
      </div>
    )
  }
}

function renderMoves(h, { moves, playerOne, playerTwo }) {
  if (!moves.length) {
    return 'none yet'
  }

  const names = [playerOne.username, playerTwo.username]
  let currentPlayer = 1

  const rows = moves.map(move => {
    const username = names[currentPlayer - 1]
    currentPlayer = currentPlayer === 1 ? 2 : 1

    return (
      <tr>
        <td>{username}</td>
        <td>{move}</td>
      </tr>
    )
  })

  return (
    <table class={style.movesTable}>
      <tr>
        <th>Player</th>
        <th>Move</th>
      </tr>
      {rows}
    </table>
  )
}

function renderMoveInput(h, { activePlayer, userIsPlaying, isMyTurn, setPendingMove, sendPendingMove }) {
  if (!userIsPlaying || !isMyTurn) {
    return <p>waiting for {activePlayer.username} to move...</p>
  }

  return (
    <div>
      <input type="text"
              placeholder="your move"
              onInput={setPendingMove}/>
      <button onClick={sendPendingMove}>
        send
      </button>
    </div>
  )
}
