import isString from 'lodash/isString'
import { Map } from 'immutable'

let translations = Map()

export const set = (trs) => {
  translations = trs
}

export const t = (path) => {
  if (isString(path)) path = path.split('.')
  return translations.getIn(path)
}
