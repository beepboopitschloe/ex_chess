import { anonymousRequest } from './api'

export function loadAuthToken({ commit }) {
  return Promise.resolve()
    .then(() => {
      try {
        const identity = JSON.parse(localStorage.getItem('exchess.identity'))
        const jwt = JSON.parse(localStorage.getItem('exchess.jwt'))
        commit('setAuth', { identity, jwt })
      } catch(e) {
        console.warn('error loading stored auth token:', e)
      }
    })
}

export function signup({ commit }, data) {
  return anonymousRequest('auth/signup', {
    method: 'post',
    data
  })
    .then(result => commit('setAuth', result))
    .catch(err => commit('setNetworkError', err))
}

export function login({ commit }, data) {
  return anonymousRequest('auth/login', {
    method: 'post',
    data
  })
    .then(result => commit('setAuth', result))
    .catch(err => commit('setNetworkError', err))
}

export function logout({ commit }) {
  commit('setAuth', { identity: null, jwt: null })
}
