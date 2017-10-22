import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import moment from 'moment'
import { Checkbox } from 'muicss/react'

const daysLeft = (date) =>
  Math.ceil(moment(date, 'YYYY-MM-DD').diff(moment(), 'days', true))

export default class Redemption extends PureComponent {
  static propTypes = {
    redemption: ImmutablePropTypes.map.isRequired,
    onCollect: PropTypes.func.isRequired
  }

  collect() {
    const { onCollect } = this.props
    if (!confirm('Are you sure?')) return
    onCollect()
  }

  render() {
    const { redemption } = this.props

    return <tr>
      <td>{redemption.get('name')}</td>
      <td>{redemption.get('amount')}</td>
      <td>{redemption.get('date')} ({daysLeft(redemption.get('date'))})</td>
      <td>
        <Checkbox disabled={redemption.get('collected')} defaultChecked={redemption.get('collected')}
          onChange={::this.collect}
        />
      </td>
    </tr>
  }
}
