import axios from 'axios'

export const fetch = () =>
  axios.get('/api/private/redemptions')
    .then(({ data }) => data.get('redemptions'))

export const update = (id, params) =>
  axios.put(`/api/private/redemptions/${id}`, { redemption: params })
    .then(({ data }) => data.get('redemption'))
