import axios from 'axios'

export const fetch = () =>
  axios.get('/api/private/translations')
    .then(({ data }) => data.get('translations'))
