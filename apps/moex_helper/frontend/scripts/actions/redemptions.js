import { createAction } from 'redux-actions'
import * as redemptionsApi from '../api/redemptions'
import listToCidMap from '../helpers/list-to-cid-map'

const fetchStart = createAction('REDEMPTIONS_FETCH_START')
const fetchSuccess = createAction('REDEMPTIONS_FETCH_SUCCESS')
const fetchFail = createAction('REDEMPTIONS_FETCH_FAIL')
const updateStart = createAction('REDEMPTIONS_UPDATE_START')
const updateSuccess = createAction('REDEMPTIONS_UPDATE_SUCCESS')
const updateFail = createAction('REDEMPTIONS_UPDATE_FAIL')

export const fetch = () => (dispatch) => {
  dispatch(fetchStart())
  return redemptionsApi.fetch()
    .then((redemptions) => {
      redemptions = listToCidMap(redemptions)
      dispatch(fetchSuccess(redemptions))
      return redemptions
    })
    .catch(() => { dispatch(fetchFail()) })
}

export const update = (cid, params) => (dispatch, getState) => {
  const id = getState().getIn(['redemptions', 'items', cid, 'id'])

  dispatch(updateStart(cid))
  return redemptionsApi.update(id, params)
    .then((redemption) => {
      dispatch(updateSuccess({ cid, redemption }))
      return redemption
    })
    .catch(() => { dispatch(updateFail(cid)) })
}
