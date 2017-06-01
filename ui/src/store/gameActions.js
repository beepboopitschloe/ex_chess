import { request, handleError, socket } from './api'

export function listGamesByStatus({ commit, getters }, status) {
  return request(`game?status=${status}`, getters.jwt)
    .then(games => commit('setGameList', games))
    .catch(handleError({ commit }))
}

export function loadGame({ commit, getters }, id) {
  return request(`game/${id}`, getters.jwt)
    .then(game => {
      commit('addGameToList', game)
      return game
    })
    .catch(handleError({ commit }))
}

export function createGame(context, status) {
  const { commit, getters } = context

  return request('game', getters.jwt, {
    method: 'post'
  })
    .then(game => {
      commit('addGameToList', game)
      return joinGame(context, game)
    })
    .catch(handleError({ commit }))
}

export function joinGameById(context, id) {
  const { commit } = context

  return loadGame(context, id)
    .then(game => joinGame(context, game))
    .catch(handleError({ commit }))
}

export function joinGame({ commit, getters }, game) {
  const channel = socket.channel(`game:${game.id}`, { jwt: getters.jwt })

  channel.on('game_updated', game => {
    commit('setCurrentGame', game)
  })

  return new Promise((resolve, reject) => {
    channel.join()
      .receive('ok', game => {
        commit('setCurrentGame', game)
        commit('setGameChannel', channel)
        return resolve(game)
      })
      .receive('error', err => {
        commit('setSocketError', err)
        return reject(err)
      })
  })
}

export function sendMove({ commit, getters }, move) {
  const channel = getters.gameChannel

  return new Promise((resolve, reject) => {
    channel.push('send_move', { move })
      .receive('ok', ({ game }) => {
        commit('setCurrentGame', game)
        return resolve(game)
      })
      .receive('error', err => {
        commit('setSocketError', err)
        return reject(err)
      })
  })
}