import axios from 'axios'
import { Socket } from 'phoenix'
import { API_URL, SOCKET_URL } from '../constants'

export const socket = new Socket(SOCKET_URL, {
  logger: (kind, msg, data) => console.info(`WS :: ${kind} :: ${msg}`, data),
  transport: WebSocket
})
socket.connect()

export function anonymousRequest(path, options = {}) {
  return axios(makeOptions(options, path))
    .then(({ data }) => data.data)
}

export function request(path, jwt, options = {}) {
  return axios(makeOptions(options, path, jwt))
    .then(({ data }) => data.data)
}

export function handleError({ commit }) {
  return err => {
    commit('setNetworkError', err)
    return Promise.reject(err)
  }
}

function makeOptions(opts, path, jwt) {
  const headers = (opts.headers || {})
  if (jwt) {
    headers.authorization = jwt
  }

  const url = `${API_URL}/api/${path}`

  return {
    ...opts,
    headers,
    url
  }
}
