import { assign, get, set, union } from 'lodash'

export function setAuth(state, { identity, jwt }) {
  if (identity) {
    localStorage.setItem('exchess.identity', JSON.stringify(identity))
  } else {
    localStorage.removeItem('exchess.identity')
  }

  if (jwt) {
    localStorage.setItem('exchess.jwt', JSON.stringify(jwt))
  } else {
    localStorage.removeItem('exchess.jwt')
  }

  set(state, 'identity', identity)
  set(state, 'jwt', jwt)
}

export function setAuthorized(state, val) {
  set(state, 'authorized', val)
}

export function setNetworkError(state, err) {
  console.error('network error:', err)
  set(state, 'errors.network', err)
}

export function setSocketError(state, err) {
  set(state, 'errors.socket', err)
}

export function setGameList(state, games) {
  set(state, 'games.list', games)
}

export function addGameToList(state, game) {
  set(state, 'games.list', state.games.list.concat(game))
}

export function setCurrentGame(state, game) {
  set(state, 'games.currentGame', game)
}

export function setGameChannel(state, channel) {
  set(state, 'games.channel', channel)
}
