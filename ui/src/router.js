import Vue from 'vue'
import Router from 'vue-router'
import Lobby from './pages/Lobby'
import Login from './pages/Login'
import Play from './pages/Play'

Vue.use(Router)

export default new Router({
  mode: 'hash',
  routes: [{
    name: 'lobby',
    path: '/',
    component: Lobby
  }, {
    name: 'login',
    path: '/login',
    component: Login
  }, {
    name: 'play',
    path: '/play/:gameId',
    component: Play
  }]
})
