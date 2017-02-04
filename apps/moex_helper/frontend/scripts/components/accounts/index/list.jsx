import React, { PureComponent } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import Account from './account'

export default class List extends PureComponent {
  static propTypes = {
    accounts: ImmutablePropTypes.map.isRequired
  }

  render() {
    const { accounts } = this.props

    return <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        {accounts.valueSeq().map((account) =>
          <Account key={account.get('cid')} account={account}/>
        ).toJS()}
      </tbody>
    </table>
  }
}
