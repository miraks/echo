import { Map } from 'immutable'
import { handleActions } from 'redux-actions'

const initialState = Map({
  item: null,
  isFetching: false,
  isFailed: false
})

export default handleActions({
  CURRENT_USER_FETCH_START(state) {
    return state.merge({ isFetching: true, isFailed: false })
  },

  CURRENT_USER_FETCH_SUCCESS(state, { payload: user }) {
    return state.merge({ item: user, isFetching: false, isFailed: false })
  },

  CURRENT_USER_FETCH_FAIL(state) {
    return state.merge({ isFetching: false, isFailed: true })
  },

  CURRENT_USER_LOGIN_SUCCESS(state, { payload: user }) {
    return state.set('item', user)
  }
}, initialState)
