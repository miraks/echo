import { Map } from 'immutable'
import uuid from 'uuid/v4'

export default (items) =>
  items.reduce((map, item) => {
    if (!item.get('cid')) item = item.set('cid', uuid())
    return map.set(item.get('cid'), item)
  }, Map())
