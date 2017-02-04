import React, { PureComponent, PropTypes } from 'react'
import { Button } from 'muicss/react'

export default class Add extends PureComponent {
  static propTypes = {
    onClick: PropTypes.func.isRequired
  }

  render() {
    const { onClick } = this.props

    return <Button variant="raised" color="primary" onClick={onClick}>
      Add
    </Button>
  }
}
