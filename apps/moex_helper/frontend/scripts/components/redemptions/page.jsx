import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import { connect } from 'react-redux'
import * as redemptionActions from '../../actions/redemptions'
import Redemption from './redemption'

class RedemptionsPage extends PureComponent {
  static propTypes = {
    redemptions: ImmutablePropTypes.map.isRequired,
    fetchRedemptions: PropTypes.func.isRequired,
    updateRedemption: PropTypes.func.isRequired
  }

  componentDidMount() {
    const { fetchRedemptions } = this.props
    fetchRedemptions()
  }

  collect(redemption) {
    const { updateRedemption } = this.props
    updateRedemption(redemption.get('cid'), { collected: true })
  }

  render() {
    const { redemptions } = this.props

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
        {redemptions.valueSeq().sortBy((redemption) => redemption.get('date')).map((redemption) =>
          <Redemption key={redemption.get('id')} redemption={redemption} onCollect={this.collect.bind(this, redemption)}/>
        ).toJS()}
      </tbody>
    </table>
  }
}

const mapStateToProps = (state) => {
  return {
    redemptions: state.getIn(['redemptions', 'items'])
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    fetchRedemptions() { return dispatch(redemptionActions.fetch()) },
    updateRedemption(cid, params) { return dispatch(redemptionActions.update(cid, params)) }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(RedemptionsPage)
