import axios from 'axios'

export const fetch = () =>
  axios.get('/api/private/accounts')
    .then(({ data }) => data.get('accounts'))

export const save = (id, params) => {
  const prefix = '/api/private/accounts'
  const [url, method] = id ? [`${prefix}/${id}`, 'put'] : [prefix, 'post']

  return axios[method](url, { account: params })
    .then(({ data }) => data.get('account'))
}

export const remove = (id) =>
  axios.delete(`/api/private/accounts/${id}`)
