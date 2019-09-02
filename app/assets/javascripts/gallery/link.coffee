@Link = createReactClass
  onClick: (e) ->
    if @props.onClick
      @props.onClick e

    if e.button == 0
      e.preventDefault()
      Store.navigate @props.href

  render: ->
    attrs = {}
    Object.assign attrs, @props
    delete attrs.children
    attrs.onClick = @onClick

    React.createElement "a", attrs, @props.children
