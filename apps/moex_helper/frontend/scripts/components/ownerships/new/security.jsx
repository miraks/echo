import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import { Button } from 'muicss/react'

export default class Security extends PureComponent {
  static propTypes = {
    security: ImmutablePropTypes.map.isRequired,
    onSelect: PropTypes.func.isRequired
  }

  render() {
    const { security, onSelect } = this.props

    return <tr>
      <td>{security.get('code')}</td>
      <td>{security.get('shortname')}</td>
      <td>{security.get('name')}</td>
      <td>{security.get('emitentTitle')}</td>
      <td>
        <Button color="primary" onClick={() => onSelect(security)}>Select</Button>
      </td>
    </tr>
  }
}
