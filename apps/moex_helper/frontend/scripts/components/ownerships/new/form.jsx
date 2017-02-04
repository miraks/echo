import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import { compose } from 'redux'
import { connect } from 'react-redux'
import { Field, reduxForm } from 'redux-form/immutable'
import { Form, Option, Button } from 'muicss/react'
import * as accountActions from '../../../actions/accounts'
import Input from '../../shared/input'
import Select from '../../shared/select'

class NewSecurityForm extends PureComponent {
  static propTypes = {
    accounts: ImmutablePropTypes.map.isRequired,
    fetchAccounts: PropTypes.func.isRequired,
    handleSubmit: PropTypes.func.isRequired
  }

  componentDidMount() {
    const { fetchAccounts } = this.props
    fetchAccounts()
  }

  render() {
    const { accounts, handleSubmit } = this.props

    return <Form onSubmit={handleSubmit}>
      <Field name="amount" type="text" label="Amount" floatingLabel component={Input}/>
      <Field name="price" type="text" label="Price" floatingLabel component={Input}/>
      <Field name="comment" type="text" label="Comment" floatingLabel component={Input}/>
      <Field name="account_id" component={Select}>
        <Option value="" label=""/>
        {accounts.valueSeq().map((option) =>
          <Option key={option.get('id')} value={option.get('id')} label={option.get('name')}/>
        ).toJS()}
      </Field>
      <Button variant="raised" color="primary">Save</Button>
    </Form>
  }
}

const mapStateToProps = (state) => {
  return {
    accounts: state.getIn(['accounts', 'items'])
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    fetchAccounts() { return dispatch(accountActions.fetch()) }
  }
}

export default compose(connect(mapStateToProps, mapDispatchToProps), reduxForm({ form: 'new-security' }))(NewSecurityForm)
