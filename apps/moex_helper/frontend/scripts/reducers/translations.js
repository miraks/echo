import { Map } from 'immutable'
import { handleActions } from 'redux-actions'

const initialState = Map({
  items: Map(),
  isFetching: false,
  isFailed: false
})

export default handleActions({
  TRANSLATIONS_FETCH_START(state) {
    return state.merge({ isFetching: true, isFailed: false })
  },

  TRANSLATIONS_FETCH_SUCCESS(state, { payload: translations }) {
    return state.merge({ items: translations, isFetching: false, isFailed: false })
  },

  TRANSLATIONS_FETCH_FAIL(state) {
    return state.merge({ isFetching: false, isFailed: true })
  }
}, initialState)
