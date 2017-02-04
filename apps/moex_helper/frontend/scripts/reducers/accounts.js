import { Map } from 'immutable'
import uuid from 'uuid/v4'
import { handleActions } from 'redux-actions'

const initialState = Map({
  items: Map(),
  isFetching: false,
  isFailed: false
})

export default handleActions({
  ACCOUNTS_FETCH_START(state) {
    return state.merge({ isFetching: true, isFailed: false })
  },

  ACCOUNTS_FETCH_SUCCESS(state, { payload: accounts }) {
    return state.merge({ items: accounts, isFetching: false, isFailed: false })
  },

  ACCOUNTS_FETCH_FAIL(state) {
    return state.merge({ isFetching: false, isFailed: true })
  },

  ACCOUNTS_ADD(state) {
    const cid = uuid()
    const account = Map({ cid })
    return state.setIn(['items', cid], account)
  },

  ACCOUNTS_SAVE_SUCCESS(state, { payload: { cid, account } }) {
    return state.setIn(['items', cid], account.set('cid', cid))
  },

  ACCOUNTS_REMOVE_SUCCESS(state, { payload: cid }) {
    return state.deleteIn(['items', cid])
  }
}, initialState)
