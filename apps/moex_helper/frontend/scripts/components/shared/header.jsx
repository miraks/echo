import React from 'react'
import { Link } from 'react-router'
import { Appbar } from 'muicss/react'

export default () =>
  <Appbar className="layout_header">
    <Link className="layout_header-title" to="/">
      MOEX Helper
    </Link>
    <div className="layout_header-links">
      <Link className="layout_header-link" to="/accounts">Accounts</Link>
      <Link className="layout_header-link" to="/coupons">Coupons</Link>
      <Link className="layout_header-link" to="/redemptions">Redemptions</Link>
      <Link className="layout_header-link" to="/ownerships/new">Add security</Link>
    </div>
  </Appbar>
