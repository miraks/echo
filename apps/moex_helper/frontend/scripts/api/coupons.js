import axios from 'axios'

export const fetch = () =>
  axios.get('/api/private/coupons')
    .then(({ data }) => data.get('coupons'))

export const update = (id, params) =>
  axios.put(`/api/private/coupons/${id}`, { coupon: params })
    .then(({ data }) => data.get('coupon'))
