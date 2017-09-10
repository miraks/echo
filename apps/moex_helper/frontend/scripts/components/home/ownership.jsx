import React, { PureComponent, PropTypes } from 'react'
import ImmutablePropTypes from 'react-immutable-proptypes'
import { compose } from 'redux'
import { connect } from 'react-redux'
import { Field, reduxForm } from 'redux-form/immutable'
import { Button } from 'muicss/react'
import * as ownershipActions from '../../actions/ownerships'
import Input from '../shared/input'

class Ownership extends PureComponent {
  static propTypes = {
    ownership: ImmutablePropTypes.map.isRequired,
    isFirst: PropTypes.bool.isRequired,
    isLast: PropTypes.bool.isRequired,
    columns: ImmutablePropTypes.listOf(ImmutablePropTypes.map).isRequired,
    moveUp: PropTypes.func.isRequired,
    moveDown: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
    remove: PropTypes.func.isRequired,
    handleSubmit: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)

    this.state = {
      edit: false
    }
  }

  format(column) {
    const { ownership } = this.props

    const value = ownership.getIn(column.get('path').split('.'))

    switch (column.get('path')) {
      case 'security.data.prevprice': {
        const diff = value - ownership.get('price')
        const roundDiff = diff.toFixed(2)
        const diffStr = diff > 0 ? `+${roundDiff}` : roundDiff
        return `${value} (${diffStr})`
      }

      default:
        return value
    }
  }

  remove() {
    const { remove } = this.props
    if (!confirm('Are you sure?')) return
    remove()
  }

  column(column) {
    const { edit } = this.state

    if (column.get('editable') && edit) {
      return <Field name={column.get('path')} type="text" hint={column.get('name')} component={Input}/>
    }

    return this.format(column)
  }

  moveUp() {
    const { isFirst, moveUp } = this.props

    if (isFirst) return
    return <Button className="ownership_move-button m-up" size="small" color="primary" variant="fab" onClick={moveUp}>➔</Button>
  }

  moveDown() {
    const { isLast, moveDown } = this.props

    if (isLast) return
    return <Button className="ownership_move-button m-down" size="small" color="primary" variant="fab" onClick={moveDown}>➔</Button>
  }

  edit() {
    const { edit } = this.state

    if (edit) return

    const startEdit = () => { this.setState({ edit: true }) }
    return <Button color="primary" onClick={startEdit}>Edit</Button>
  }

  update() {
    const { update, handleSubmit } = this.props
    const { edit } = this.state

    if (!edit) return

    const onSubmit = (params) => {
      update(params).then(() => { this.setState({ edit: false }) })
    }

    return <Button color="primary" onClick={handleSubmit(onSubmit)}>Save</Button>
  }

  render() {
    const { columns } = this.props

    return <tr className="ownership">
      <td>
        <div className="ownership_move-buttons">
          {::this.moveUp()}
          {::this.moveDown()}
        </div>
      </td>
      {columns.map((column) =>
        <td key={column.get('path')}>{::this.column(column)}</td>
      ).toJS()}
      <td>
        <div className="ownership_action-buttons">
          {::this.edit()}
          {::this.update()}
          <Button color="danger" onClick={::this.remove}>Remove</Button>
        </div>
      </td>
    </tr>
  }
}

const mapStateToProps = (state, { ownership }) => {
  return { form: `ownership-${ownership.get('cid')}` }
}

const mapDispatchToProps = (dispatch, { ownership }) => {
  return {
    moveUp() { return dispatch(ownershipActions.moveUp(ownership.get('cid'))) },
    moveDown() { return dispatch(ownershipActions.moveDown(ownership.get('cid'))) },
    update(params) { return dispatch(ownershipActions.update(ownership.get('cid'), params)) },
    remove() { return dispatch(ownershipActions.remove(ownership.get('cid'))) }
  }
}

export default compose(connect(mapStateToProps, mapDispatchToProps), reduxForm())(Ownership)
