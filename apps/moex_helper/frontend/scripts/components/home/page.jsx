import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import { fromJS } from 'immutable'
import { connect } from 'react-redux'
import { t } from '../../helpers/i18n'
import * as ownershipActions from '../../actions/ownerships'
import Ownership from './ownership'

class HomePage extends PureComponent {
  static propTypes = {
    fetchOwnerships: PropTypes.func.isRequired,
    ownerships: ImmutablePropTypes.map.isRequired
  }

  constructor(props) {
    super(props)

    this.state = {
      columns: fromJS([
        { name: 'Account', path: 'account.name', editable: false },
        { name: 'Code', path: 'security.code', editable: false },
        { name: t('en.security.data.secname'), path: 'security.data.secname', editable: false },
        { name: 'Amount', path: 'amount', editable: true },
        { name: 'Original price', path: 'price', editable: true },
        { name: t('en.security.data.prevprice'), path: 'security.data.prevprice', editable: false },
        { name: t('en.security.data.couponvalue'), path: 'security.data.couponvalue', editable: false },
        { name: t('en.security.data.nextcoupon'), path: 'security.data.nextcoupon', editable: false },
        { name: t('en.security.data.matdate'), path: 'security.data.matdate', editable: false }
      ])
    }
  }

  componentDidMount() {
    const { fetchOwnerships } = this.props
    fetchOwnerships()
  }

  render() {
    const { ownerships } = this.props
    const { columns } = this.state

    return <table>
      <thead>
        <tr>
          <th/>
          {columns.map((column) =>
            <th key={column.get('path')}>{column.get('name')}</th>
          ).toJS()}
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        {ownerships.valueSeq().sortBy((ownership) => ownership.get('index')).map((ownership, index) =>
          <Ownership key={ownership.get('id')} ownership={ownership} isFirst={index === 0}
            isLast={index === ownerships.size - 1} columns={columns}
          />
        ).toJS()}
      </tbody>
    </table>
  }
}

const mapStateToProps = (state) => {
  return {
    ownerships: state.getIn(['ownerships', 'items'])
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    fetchOwnerships() { return dispatch(ownershipActions.fetch()) }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(HomePage)
