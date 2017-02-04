import axios from 'axios'

export const fetch = () =>
  axios.get('/api/private/current_user')
    .then(({ data }) => data.get('currentUser'))

export const login = (params) =>
  axios.post('/api/private/session', params)
    .then(({ data }) => data.get('currentUser'))
