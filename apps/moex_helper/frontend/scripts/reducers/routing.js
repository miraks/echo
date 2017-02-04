import { Map } from 'immutable'
import { LOCATION_CHANGE } from 'react-router-redux'
import { handleActions } from 'redux-actions'

const initialState = Map({
  locationBeforeTransitions: null
})

export default handleActions({
  [LOCATION_CHANGE](state, { payload }) {
    return state.set('locationBeforeTransitions', payload)
  }
}, initialState)
