import { fromJS, Iterable } from 'immutable'
import camelCase from 'lodash/camelCase'
import snakeCase from 'lodash/snakeCase'
import isArray from 'lodash/isArray'
import isPlainObject from 'lodash/isPlainObject'
import axios from 'axios'
import deepMapKeys from '../helpers/deep-map-keys'

axios.interceptors.request.use((request) => {
  if (Iterable.isIterable(request.data)) request.data = deepMapKeys(request.data, snakeCase).toJS()
  return request
})

axios.interceptors.response.use((response) => {
  const { data } = response
  if (isPlainObject(data) || isArray(data)) response.data = deepMapKeys(fromJS(data), camelCase)
  return response
})
