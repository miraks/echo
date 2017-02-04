import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import { connect } from 'react-redux'
import { Container } from 'muicss/react'
import * as i18n from '../helpers/i18n'
import * as translationActions from '../actions/translations'
import * as currentUserActions from '../actions/current-user'
import Loader from './shared/loader'
import Header from './shared/header'
import LoginPage from './login/page'

class App extends PureComponent {
  static propTypes = {
    fetchTranslations: PropTypes.func.isRequired,
    fetchCurrentUser: PropTypes.func.isRequired,
    isFetching: PropTypes.bool.isRequired,
    currentUser: ImmutablePropTypes.map,
    children: PropTypes.node.isRequired
  }

  componentDidMount() {
    const { fetchTranslations, fetchCurrentUser } = this.props
    fetchTranslations().then((translations) => { i18n.set(translations) })
    fetchCurrentUser()
  }

  content() {
    const { isFetching, currentUser, children } = this.props

    if (isFetching) return <Loader/>
    if (!currentUser) return <LoginPage/>
    return children
  }

  render() {
    return <div className="layout">
      <Header/>
      <Container className="layout_content">
        {::this.content()}
      </Container>
    </div>
  }
}

const mapStateToProps = (state) => {
  return {
    isFetching: ['translations', 'currentUser'].some((store) => state.getIn([store, 'isFetching'])),
    currentUser: state.getIn(['currentUser', 'item'])
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    fetchTranslations() { return dispatch(translationActions.fetch()) },
    fetchCurrentUser() { return dispatch(currentUserActions.fetch()) }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(App)
