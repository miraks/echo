import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import moment from 'moment'
import { Checkbox } from 'muicss/react'

const daysLeft = (date) =>
  Math.ceil(moment(date, 'YYYY-MM-DD').diff(moment(), 'days', true))

export default class Coupon extends PureComponent {
  static propTypes = {
    coupon: ImmutablePropTypes.map.isRequired,
    onCollect: PropTypes.func.isRequired
  }

  collect() {
    const { onCollect } = this.props
    if (!confirm('Are you sure?')) return
    onCollect()
  }

  render() {
    const { coupon } = this.props

    return <tr>
      <td>{coupon.getIn(['account', 'name'])}</td>
      <td>{coupon.get('name')}</td>
      <td>{coupon.get('amount')}</td>
      <td>{coupon.get('date')} ({daysLeft(coupon.get('date'))})</td>
      <td>
        <Checkbox disabled={coupon.get('collected')} defaultChecked={coupon.get('collected')}
          onChange={::this.collect}
        />
      </td>
    </tr>
  }
}
