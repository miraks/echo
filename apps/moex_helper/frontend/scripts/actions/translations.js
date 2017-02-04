import { createAction } from 'redux-actions'
import * as translationsApi from '../api/translations'

const fetchStart = createAction('TRANSLATIONS_FETCH_START')
const fetchSuccess = createAction('TRANSLATIONS_FETCH_SUCCESS')
const fetchFail = createAction('TRANSLATIONS_FETCH_FAIL')

export const fetch = () => (dispatch) => {
  dispatch(fetchStart())
  return translationsApi.fetch()
    .then((translations) => {
      dispatch(fetchSuccess(translations))
      return translations
    })
    .catch(() => { dispatch(fetchFail()) })
}
