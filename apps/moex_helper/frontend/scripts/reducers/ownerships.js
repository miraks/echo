import { Map, OrderedMap } from 'immutable'
import { handleActions } from 'redux-actions'

const initialState = Map({
  items: OrderedMap(),
  isFetching: false,
  isFailed: false
})

export default handleActions({
  OWNERSHIPS_FETCH_START(state) {
    return state.merge({ isFetching: true, isFailed: false })
  },

  OWNERSHIPS_FETCH_SUCCESS(state, { payload: ownerships }) {
    return state.merge({ items: ownerships, isFetching: false, isFailed: false })
  },

  OWNERSHIPS_FETCH_FAIL(state) {
    return state.merge({ isFetching: false, isFailed: true })
  },

  OWNERSHIPS_UPDATE_SUCCESS(state, { payload: { cid, ownership } }) {
    return state.setIn(['items', cid], ownership.set('cid', cid))
  },

  OWNERSHIPS_REMOVE_SUCCESS(state, { payload: cid }) {
    return state.deleteIn(['items', cid])
  }
}, initialState)
