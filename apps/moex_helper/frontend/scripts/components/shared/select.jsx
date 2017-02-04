import omit from 'lodash/omit'
import React, { PureComponent, PropTypes } from 'react'
import { Select } from 'muicss/react'

export default class WrappedSelect extends PureComponent {
  static propTypes = {
    input: PropTypes.object.isRequired
  }

  render() {
    const { input, ...other } = this.props
    const custom = omit(other, 'meta')

    return <Select {...input} {...custom}/>
  }
}
