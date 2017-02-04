import { createAction } from 'redux-actions'
import * as currentUserApi from '../api/current-user'

const fetchStart = createAction('CURRENT_USER_FETCH_START')
const fetchSuccess = createAction('CURRENT_USER_FETCH_SUCCESS')
const fetchFail = createAction('CURRENT_USER_FETCH_FAIL')
const loginStart = createAction('CURRENT_USER_LOGIN_START')
const loginSuccess = createAction('CURRENT_USER_LOGIN_SUCCESS')
const loginFail = createAction('CURRENT_USER_LOGIN_FAIL')

export const fetch = () => (dispatch) => {
  dispatch(fetchStart())
  return currentUserApi.fetch()
    .then((currentUser) => {
      dispatch(fetchSuccess(currentUser))
      return currentUser
    })
    .catch(() => { dispatch(fetchFail()) })
}

export const login = (params) => (dispatch) => {
  dispatch(loginStart())
  return currentUserApi.login(params)
    .then((currentUser) => {
      dispatch(loginSuccess(currentUser))
      return currentUser
    })
    .catch(() => { dispatch(loginFail) })
}
