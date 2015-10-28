@NavBar = React.createClass
  getInitialState: ->
    newSearch: ''

  changeNewSearch: (e) ->
    @setState
      newSearch: e.target.value

  handleSearch: (e) ->
    e.preventDefault()
    Store.search @state.newSearch

  render: ->
    <nav id="main-navbar" className="navbar navbar-default">
      <div className="container-fluid">
        <div className="navbar-header">
          <button className="navbar-toggle collapsed" type="button" data-toggle="collapse" data-target="#hypercheese-navbar-collapse-1">
            <span className="sr-only">
              Toggle Navigation
            </span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
          </button>
          <a className="navbar-brand">HyperCheese</a>
        </div>

        <div className="collapse navbar-collapse" id="hypercheese-navbar-collapse-1">
          <ul className="nav navbar-nav"></ul>

          <div>
            <ul className="nav navbar-nav">
              <li>
                <a href="#/tags">Tags</a>
              </li>
            </ul>
            <form className="navbar-form navbar-left" role="Search" onSubmit={@handleSearch}>
              <div className="form-group">
                <input className="form-control" placeholder="Search" defaultValue={Store.state.query} value={@state.newSearch} onChange={@changeNewSearch} type="text"/>
              </div>
            </form>
            <p className="navbar-text">
              Count: {Store.state.resultCount}
            </p>
          </div>

          <ul className="nav navbar-nav navbar-right">
            <li>
              <a href="http://www.rickety.us/sundry/hypercheese-help/">Help</a>
            </li>
            <li>
              <a href="/users/sign_out" data-method="delete" rel="nofollow">Sign out</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
