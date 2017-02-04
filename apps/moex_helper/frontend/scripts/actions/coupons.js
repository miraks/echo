import { createAction } from 'redux-actions'
import * as couponsApi from '../api/coupons'
import listToCidMap from '../helpers/list-to-cid-map'

const fetchStart = createAction('COUPONS_FETCH_START')
const fetchSuccess = createAction('COUPONS_FETCH_SUCCESS')
const fetchFail = createAction('COUPONS_FETCH_FAIL')
const updateStart = createAction('COUPONS_UPDATE_START')
const updateSuccess = createAction('COUPONS_UPDATE_SUCCESS')
const updateFail = createAction('COUPONS_UPDATE_FAIL')

export const fetch = () => (dispatch) => {
  dispatch(fetchStart())
  return couponsApi.fetch()
    .then((coupons) => {
      coupons = listToCidMap(coupons)
      dispatch(fetchSuccess(coupons))
      return coupons
    })
    .catch(() => { dispatch(fetchFail()) })
}

export const update = (cid, params) => (dispatch, getState) => {
  const id = getState().getIn(['coupons', 'items', cid, 'id'])

  dispatch(updateStart(cid))
  return couponsApi.update(id, params)
    .then((coupon) => {
      dispatch(updateSuccess({ cid, coupon }))
      return coupon
    })
    .catch(() => { dispatch(updateFail(cid)) })
}
