import React, { PureComponent, PropTypes } from 'react'
import { connect } from 'react-redux'
import { login } from '../../actions/current-user'
import LoginForm from './form'

class LoginPage extends PureComponent {
  static propTypes = {
    login: PropTypes.func.isRequired
  }

  handleSubmit(params) {
    this.props.login(params)
  }

  render() {
    return <LoginForm onSubmit={::this.handleSubmit}/>
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    login(params) { return dispatch(login(params)) }
  }
}

export default connect(null, mapDispatchToProps)(LoginPage)
