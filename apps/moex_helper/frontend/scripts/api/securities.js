import axios from 'axios'

export const search = (query) =>
  axios.get('/api/private/securities/search', { params: { query } })
    .then(({ data }) => data.get('securities'))
