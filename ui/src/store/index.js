import Vue from 'vue'
import Vuex from 'vuex'
import { get } from 'lodash'
import * as mutations from './mutations'
import * as authActions from './authActions'
import * as gameActions from './gameActions'

Vue.use(Vuex)

const state = {
  identity: null,
  jwt: null,
  games: {
    loading: false,
    list: [],
    currentGame: null,
    channel: null
  },
  errors: {
    network: null,
    socket: null
  }
}

const getters = {
  authorized: state => !!state.identity && !!state.jwt, // TODO check JWT expiry
  identity: state => get(state, 'identity'),
  jwt: state => get(state, 'jwt'),
  loadingGames: state => get(state, 'games.loading'),
  availableGames: state => get(state, 'games.list'),
  currentGame: state => get(state, 'games.currentGame'),
  gameChannel: state => get(state, 'games.channel'),
  networkError: state => get(state, 'errors.network'),
  socketError: state => get(state, 'errors.socket')
}

const actions = {
  ...authActions,
  ...gameActions
}

const store = new Vuex.Store({
  state,
  mutations,
  getters,
  actions
})

export default store
