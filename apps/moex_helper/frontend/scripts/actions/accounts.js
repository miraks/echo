import { createAction } from 'redux-actions'
import * as accountsApi from '../api/accounts'
import listToCidMap from '../helpers/list-to-cid-map'

const fetchStart = createAction('ACCOUNTS_FETCH_START')
const fetchSuccess = createAction('ACCOUNTS_FETCH_SUCCESS')
const fetchFail = createAction('ACCOUNTS_FETCH_FAIL')
const saveStart = createAction('ACCOUNTS_SAVE_START')
const saveSuccess = createAction('ACCOUNTS_SAVE_SUCCESS')
const saveFail = createAction('ACCOUNTS_SAVE_FAIL')
const removeStart = createAction('ACCOUNTS_REMOVE_START')
const removeSuccess = createAction('ACCOUNTS_REMOVE_SUCCESS')
const removeFail = createAction('ACCOUNTS_REMOVE_FAIL')
export const add = createAction('ACCOUNTS_ADD')

export const fetch = () => (dispatch) => {
  dispatch(fetchStart())
  return accountsApi.fetch()
    .then((accounts) => {
      accounts = listToCidMap(accounts)
      dispatch(fetchSuccess(accounts))
      return accounts
    })
    .catch(() => { dispatch(fetchFail()) })
}

export const save = (cid, params) => (dispatch, getState) => {
  const id = getState().getIn(['accounts', 'items', cid, 'id'])

  dispatch(saveStart(cid))
  return accountsApi.save(id, params)
    .then((account) => {
      dispatch(saveSuccess({ cid, account }))
      return account
    })
    .catch(() => { dispatch(saveFail(cid)) })
}

export const remove = (cid) => (dispatch, getState) => {
  const id = getState().getIn(['accounts', 'items', cid, 'id'])

  if (!id) {
    dispatch(removeSuccess(cid))
    return Promise.resolve()
  }

  dispatch(removeStart(cid))
  return accountsApi.remove(id)
    .then(() => { dispatch(removeSuccess(cid)) })
    .catch(() => { dispatch(removeFail(cid)) })
}
