export const sort = (ownerships) =>
  ownerships.sort((ownership1, ownership2) => {
    if (ownership1.get('position') < ownership2.get('position')) return -1
    if (ownership1.get('position') > ownership2.get('position')) return 1
    if (ownership1.get('id') < ownership2.get('id')) return -1
    if (ownership1.get('id') > ownership2.get('id')) return 1
    return 0
  })
