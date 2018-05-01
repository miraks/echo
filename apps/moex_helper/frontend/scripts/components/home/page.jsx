import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import { fromJS, OrderedMap } from 'immutable'
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
        { name: 'Account', path: 'account.name', footer: false, editable: false },
        { name: 'Code', path: 'security.code', footer: false, editable: false },
        { name: t('en.security.data.secname'), path: 'security.data.secname', footer: false, editable: false },
        { name: 'Amount', path: 'amount', footer: false, editable: true },
        { name: 'Original price', path: 'price', footer: false, editable: true },
        { name: t('en.security.data.prevprice'), path: 'security.data.prevprice', footer: false, editable: false },
        { name: t('en.security.data.couponvalue'), path: 'security.data.couponvalue', footer: false, editable: false },
        { name: t('en.security.data.nextcoupon'), path: 'security.data.nextcoupon', footer: false, editable: false },
        { name: 'Next redemption amount', path: 'security.nextRedemptionAmount', footer: false, editable: false },
        { name: 'Next redemption', path: 'security.nextRedemptionAt', footer: false, editable: false },
        { name: t('en.security.data.matdate'), path: 'security.data.matdate', footer: false, editable: false },
        { name: 'Total value', path: 'totalValue', footer: 'totalValues', editable: false }
      ])
    }
  }

  componentDidMount() {
    const { fetchOwnerships } = this.props
    fetchOwnerships()
  }

  totalValues() {
    const { ownerships } = this.props
    return ownerships
      .valueSeq()
      .reduce((sums, ownership) => {
        const currency = ownership.getIn(['security', 'data', 'faceunit'])
        return sums.set(currency, sums.get(currency, 0) + ownership.get('totalValue'))
      }, OrderedMap())
      .entrySeq()
      .map(([currency, sum]) => `${sum.toFixed(2)} ${t(`en.currencySign.${currency.toLowerCase()}`)}`)
      .join(', ')
  }

  render() {
    const { ownerships } = this.props
    const { columns } = this.state

    return <table className="ownerships">
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
      <tfoot>
        <tr>
          <td/>
          {columns.map((column, index) =>
            <td key={index}>{column.get('footer') && this[column.get('footer')]()}</td>
          ).toJS()}
          <td/>
        </tr>
      </tfoot>
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
