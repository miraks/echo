import React, { PureComponent, PropTypes } from 'react'
import { Field, reduxForm } from 'redux-form/immutable'
import { Form, Button } from 'muicss/react'
import Input from '../shared/input'

class LoginForm extends PureComponent {
  static propTypes = {
    handleSubmit: PropTypes.func.isRequired
  }

  render() {
    const { handleSubmit } = this.props

    return <Form onSubmit={handleSubmit}>
      <legend>Login</legend>
      <Field name="email" type="email" label="Email" floatingLabel component={Input}/>
      <Field name="password" type="password" label="Password" floatingLabel component={Input}/>
      <Button variant="raised" color="primary">Login</Button>
    </Form>
  }
}

export default reduxForm({ form: 'login' })(LoginForm)
