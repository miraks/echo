import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import { connect } from 'react-redux'
import * as couponActions from '../../actions/coupons'
import Coupon from './coupon'

class CouponsPage extends PureComponent {
  static propTypes = {
    coupons: ImmutablePropTypes.map.isRequired,
    fetchCoupons: PropTypes.func.isRequired,
    updateCoupon: PropTypes.func.isRequired
  }

  componentDidMount() {
    const { fetchCoupons } = this.props
    fetchCoupons()
  }

  collect(coupon) {
    const { updateCoupon } = this.props
    updateCoupon(coupon.get('cid'), { collected: true })
  }

  render() {
    const { coupons } = this.props

    return <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Amount</th>
          <th>Days left</th>
          <th>Collected</th>
        </tr>
      </thead>
      <tbody>
        {coupons.valueSeq().sortBy((coupon) => coupon.get('date')).map((coupon) =>
          <Coupon key={coupon.get('id')} coupon={coupon} onCollect={this.collect.bind(this, coupon)}/>
        ).toJS()}
      </tbody>
    </table>
  }
}

const mapStateToProps = (state) => {
  return {
    coupons: state.getIn(['coupons', 'items'])
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    fetchCoupons() { return dispatch(couponActions.fetch()) },
    updateCoupon(cid, params) { return dispatch(couponActions.update(cid, params)) }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(CouponsPage)
