doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    title -> @title
    link rel: 'stylesheet', href: '/stylesheets/style.css'
  body ->
    @body