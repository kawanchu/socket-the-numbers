express = require("express")
routes = require("./routes")
socketIO = require("socket.io")

port = process.env.PORT or 3000
app = module.exports = express.createServer()

app.configure ->
  app.set "views", __dirname + "/views"
  app.register '.coffee', require('coffeekup').adapters.express
  app.set "view engine", "coffee"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + "/public")
  
app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()
  
app.get '/', routes.index

app.listen port, ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env