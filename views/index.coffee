h1 -> @title

div '#management', ->
  ul ->
    li ->
      span 'Status: '
      span '#status', -> 'Connecting'
    li ->
      span 'People: '
      span '#people', ->
  div ->
    input type: 'button', value: 'Disconnect', id: 'disconnectBtn'
    input type: 'button', value: 'Start', id: 'startBtn', disabled: true

div '#game', ->