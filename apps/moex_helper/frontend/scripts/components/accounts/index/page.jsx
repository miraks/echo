import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import { connect } from 'react-redux'
import * as accountActions from '../../../actions/accounts'
import List from './list'
import Add from './add'

class AccountsPage extends PureComponent {
  static propTypes = {
    fetchAccounts: PropTypes.func.isRequired,
    addAccount: PropTypes.func.isRequired,
    accounts: ImmutablePropTypes.map.isRequired
  }

  componentDidMount() {
    const { fetchAccounts } = this.props
    fetchAccounts()
  }

  render() {
    const { accounts, addAccount } = this.props

    return <div>
      <Add onClick={addAccount}/>
      <List accounts={accounts}/>
    </div>
  }
}

const mapStateToProps = (state) => {
  return {
    accounts: state.getIn(['accounts', 'items'])
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    fetchAccounts() { return dispatch(accountActions.fetch()) },
    addAccount() { return dispatch(accountActions.add()) }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AccountsPage)
