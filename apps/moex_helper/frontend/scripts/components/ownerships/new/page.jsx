import React, { PureComponent } from 'react'
import Form from './form'
import Search from './search'
import * as ownershipsApi from '../../../api/ownerships'

export default class NewSecurityPage extends PureComponent {
  constructor(props) {
    super(props)

    this.state = {
      security: null
    }
  }

  setSecurity(security) {
    this.setState({ security })
  }

  createOwnership(params) {
    const { security } = this.state

    ownershipsApi.create(params.merge({ code: security.get('code') }))
      .then(() => this.setState({ security: null }))
  }

  selectedSecurity() {
    const { security } = this.state

    if (!security) return
    return <div>{security.get('name')}</div>
  }

  form() {
    const { security } = this.state

    if (!security) return
    return <Form onSubmit={::this.createOwnership}/>
  }

  render() {
    return <div>
      {::this.selectedSecurity()}
      {::this.form()}
      <Search onSelect={::this.setSecurity}/>
    </div>
  }
}
