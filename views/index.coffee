h1 -> @title
div '(2 player realtime game)'

div '#management', ->
  ul ->
    li ->
      span 'Status: '
      span '#status', ->
    li ->
      span 'Player: '
      span '#player', ->
  div ->
    input type: 'button', value: 'Disconnect', id: 'disconnectBtn', disabled: true
    input type: 'button', value: 'Start', id: 'startBtn', disabled: true

div '#game', ->