doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    title -> @title
    link rel: 'stylesheet', href: '/stylesheets/style.css'
    script src:'/javascripts/jquery-1.7.2.min.js'
    script src:'/javascripts/coffee-script.js'
    script src:'/socket.io/socket.io.js'
    script src:'/javascripts/client.coffee', type: 'text/coffeescript'
  body -> @body