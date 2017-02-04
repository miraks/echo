import React, { PureComponent, PropTypes } from 'react'
import { List } from 'immutable'
import { compose } from 'redux'
import { connect } from 'react-redux'
import { Field, reduxForm } from 'redux-form/immutable'
import { Form, Button } from 'muicss/react'
import { search } from '../../../api/securities'
import Input from '../../shared/input'
import Security from './security'

class Search extends PureComponent {
  static propTypes = {
    onSelect: PropTypes.func.isRequired,
    handleSubmit: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)

    this.state = {
      securities: List()
    }
  }

  search(params) {
    const query = params.get('query')
    search(query).then((securities) => { this.setState({ securities }) })
  }

  render() {
    const { onSelect, handleSubmit } = this.props
    const { securities } = this.state

    return <div>
      <Form onSubmit={handleSubmit(::this.search)}>
        <Field name="query" type="text" label="Query" floatingLabel component={Input}/>
        <Button variant="raised" color="primary">Search</Button>
      </Form>
      <table>
        <thead>
          <tr>
            <th>Code</th>
            <th>Short name</th>
            <th>Name</th>
            <th>Emitent</th>
            <th/>
          </tr>
        </thead>
        <tbody>
          {securities.map((security) =>
            <Security key={security.get('code')} security={security} onSelect={onSelect}/>
          ).toJS()}
        </tbody>
      </table>
    </div>
  }
}

const mapStateToProps = (state) => {
  return {
    securities: state.getIn(['securitiesSearch', 'results'])
  }
}

export default compose(connect(mapStateToProps), reduxForm({ form: 'security-search' }))(Search)
