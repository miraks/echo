import { Map } from 'immutable'
import { handleActions } from 'redux-actions'

const initialState = Map({
  items: Map(),
  isFetching: false,
  isFailed: false
})

export default handleActions({
  REDEMPTIONS_FETCH_START(state) {
    return state.merge({ isFetching: true, isFailed: false })
  },

  REDEMPTIONS_FETCH_SUCCESS(state, { payload: redemptions }) {
    return state.merge({ items: redemptions, isFetching: false, isFailed: false })
  },

  REDEMPTIONS_FETCH_FAIL(state) {
    return state.merge({ isFetching: false, isFailed: true })
  },

  REDEMPTIONS_UPDATE_SUCCESS(state, { payload: { cid, redemption } }) {
    return state.setIn(['items', cid], redemption.set('cid', cid))
  }
}, initialState)
