import axios from 'axios'

export const fetch = () =>
  axios.get('/api/private/ownerships')
    .then(({ data }) => data.get('ownerships'))

export const create = (params) =>
  axios.post('/api/private/ownerships', { ownership: params })
    .then(({ data }) => data.get('ownership'))

export const update = (id, params) =>
  axios.put(`/api/private/ownerships/${id}`, { ownership: params })
    .then(({ data }) => data.get('ownership'))

export const remove = (id) =>
  axios.delete(`/api/private/ownerships/${id}`)

export const updatePositions = (positions) =>
  axios.put('/api/private/ownerships/positions', { positions })
