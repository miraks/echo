import { Iterable } from 'immutable'

const deepMapKeys = (obj, fn) => {
  if (Iterable.isIndexed(obj)) return obj.map((value) => deepMapKeys(value, fn))
  return obj.mapEntries(([key, value]) => {
    if (Iterable.isIterable(value)) return [fn(key), deepMapKeys(value, fn)]
    return [fn(key), value]
  })
}

export default deepMapKeys
