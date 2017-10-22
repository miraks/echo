import React from 'react'
import ReactDOM from 'react-dom'
import { Map } from 'immutable'
import { createStore, applyMiddleware } from 'redux'
import { combineReducers } from 'redux-immutable'
import { Provider } from 'react-redux'
import { Router, Route, IndexRoute, browserHistory } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'
import thunk from 'redux-thunk'
import { reducer as formReducer } from 'redux-form/immutable'
import reducers from './reducers'
import App from './components/app'
import Home from './components/home/page'
import Accounts from './components/accounts/index/page'
import Coupons from './components/coupons/page'
import Redemptions from './components/redemptions/page'
import NewSecurity from './components/ownerships/new/page'

const store = createStore(
  combineReducers({
    ...reducers,
    form: formReducer
  }),
  Map(),
  applyMiddleware(thunk)
)

const history = syncHistoryWithStore(browserHistory, store, {
  selectLocationState(state) { return state.get('routing').toJS() }
})

const rootEl = document.querySelector('#root')

ReactDOM.render(
  <Provider store={store}>
    <Router history={history}>
      <Route path="/" component={App}>
        <IndexRoute component={Home}/>
        <Route path="/accounts" component={Accounts}/>
        <Route path="/coupons" component={Coupons}/>
        <Route path="/redemptions" component={Redemptions}/>
        <Route path="/ownerships/new" component={NewSecurity}/>
      </Route>
    </Router>
  </Provider>,
  rootEl
)
