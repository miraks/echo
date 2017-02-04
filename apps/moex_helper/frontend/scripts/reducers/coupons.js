import { Map } from 'immutable'
import { handleActions } from 'redux-actions'

const initialState = Map({
  items: Map(),
  isFetching: false,
  isFailed: false
})

export default handleActions({
  COUPONS_FETCH_START(state) {
    return state.merge({ isFetching: true, isFailed: false })
  },

  COUPONS_FETCH_SUCCESS(state, { payload: coupons }) {
    return state.merge({ items: coupons, isFetching: false, isFailed: false })
  },

  COUPONS_FETCH_FAIL(state) {
    return state.merge({ isFetching: false, isFailed: true })
  },

  COUPONS_UPDATE_SUCCESS(state, { payload: { cid, coupon } }) {
    return state.setIn(['items', cid], coupon.set('cid', cid))
  }
}, initialState)
