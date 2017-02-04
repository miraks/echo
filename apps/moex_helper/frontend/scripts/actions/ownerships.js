import { Map } from 'immutable'
import { createAction } from 'redux-actions'
import * as ownershipsApi from '../api/ownerships'
import * as Ownership from '../helpers/ownership'
import listToCidMap from '../helpers/list-to-cid-map'

const fetchStart = createAction('OWNERSHIPS_FETCH_START')
const fetchSuccess = createAction('OWNERSHIPS_FETCH_SUCCESS')
const fetchFail = createAction('OWNERSHIPS_FETCH_FAIL')
const updateStart = createAction('OWNERSHIPS_UPDATE_START')
const updateSuccess = createAction('OWNERSHIPS_UPDATE_SUCCESS')
const updateFail = createAction('OWNERSHIPS_UPDATE_FAIL')
const removeStart = createAction('OWNERSHIPS_REMOVE_START')
const removeSuccess = createAction('OWNERSHIPS_REMOVE_SUCCESS')
const removeFail = createAction('OWNERSHIPS_REMOVE_FAIL')

export const fetch = () => (dispatch) => {
  dispatch(fetchStart())
  return ownershipsApi.fetch()
    .then((ownerships) => {
      ownerships = Ownership.sort(listToCidMap(ownerships))
      dispatch(fetchSuccess(ownerships))
      return ownerships
    })
    .catch(() => { dispatch(fetchFail()) })
}

export const update = (cid, params) => (dispatch, getState) => {
  const id = getState().getIn(['ownerships', 'items', cid, 'id'])

  dispatch(updateStart(cid))
  return ownershipsApi.update(id, params)
    .then((ownership) => {
      dispatch(updateSuccess({ cid, ownership }))
      return ownership
    })
    .catch(() => { dispatch(updateFail(cid)) })
}

export const remove = (cid) => (dispatch, getState) => {
  const id = getState().getIn(['ownerships', 'items', cid, 'id'])

  if (!id) {
    dispatch(removeSuccess(cid))
    return Promise.resolve()
  }

  dispatch(removeStart(cid))
  return ownershipsApi.remove(id)
    .then(() => { dispatch(removeSuccess(cid)) })
    .catch(() => { dispatch(removeFail(cid)) })
}

export const move = (cid, dir) => (dispatch, getState) => {
  const change = { up: -1, down: 1 }[dir]

  const ownerships = getState().getIn(['ownerships', 'items'])
  const indexedOwnerships = ownerships.mapEntries(([_, ownership], index) => [index, ownership.set('index', index)])

  const index = indexedOwnerships.find((ownership) => ownership.get('cid') === cid).get('index')
  const otherOwnership = indexedOwnerships.find((ownership) => ownership.get('index') === index + change)

  if (!otherOwnership) return

  const swapedOwnerships = indexedOwnerships
    .setIn([index, 'index'], index + change)
    .setIn([index + change, 'index'], index)

  const positions = swapedOwnerships.reduce((map, ownership) => {
    if (ownerships.getIn([ownership.get('cid'), 'position']) === ownership.get('index')) return map
    return map.set(ownership.get('id'), ownership.get('index'))
  }, Map())

  return ownershipsApi.updatePositions(positions)
    .then(() => {
      const newOwnerships = Ownership.sort(ownerships.map((ownership) => {
        const position = positions.get(ownership.get('id'))
        if (position === undefined) return ownership
        return ownership.set('position', position)
      }))
      dispatch(fetchSuccess(newOwnerships))
      return newOwnerships
    })
}

export const moveUp = (cid) => (dispatch, getState) =>
  move(cid, 'up')(dispatch, getState)


export const moveDown = (cid) => (dispatch, getState) =>
  move(cid, 'down')(dispatch, getState)
