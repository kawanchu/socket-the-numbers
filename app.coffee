express = require("express")
stylus = require("stylus")
routes = require("./routes")
io = require("socket.io")

port = process.env.PORT || 5000
app = module.exports = express.createServer()

app.configure ->
  app.set "views", __dirname + "/views"
  app.register ".coffee", require("coffeekup").adapters.express
  app.set "view engine", "coffee"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(__dirname + "/public")
  app.use stylus.middleware(src: __dirname + "/public")
  app.use app.router
  
app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()
  
app.get "/", routes.index

app.listen port, ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

socket = io.listen(app)
count = 0
socket.configure ->
  socket.set "transports", ["xhr-polling"]
  socket.set "polling duration", 10

socket.on "connection", (client) ->
  count++
  numbers = null
  client.emit "count-change", count
  client.broadcast.emit "count-change", count
  
  client.on "disconnect", ->
    count--
    client.broadcast.emit "count-change", count
  
  client.on "game-start", ->
    numbers = [1..25].sort -> 0.5 - Math.random()
    client.emit "game-start", numbers
    client.broadcast.emit "game-start", numbers
  
  client.on "click-number", (number) ->
    index = numbers.indexOf(number)
    if index >= 0
      numbers.splice index, 1
      client.emit "click-number", ('player': 'you', 'number': number)
      client.broadcast.emit "click-number", ('player': 'challenger', 'number': number)