$ ->
##### View Classes #####
  class ManagementView
    constructor: ->
      @people = $("#people")
      @status = $("#status")
      @disconnectBtn = $("#disconnectBtn")
      @startBtn = $("#startBtn")
    
    countChange: (count) ->
      @people.html(count)
      if count == 2
        @startBtn.removeAttr("disabled")
      else
        @startBtn.attr("disabled", true)
    
    disconnect: ->
      @status.html("Not connected")
      @disconnectBtn.attr("disabled", true)
      @startBtn.attr("disabled", true)
      @people.html(null)
    
    gameStart: ->
      @startBtn.attr("disabled", true)
  

  class GameView
    constructor: (@numbers) ->
      @game = $("#game")
      @display = $("<div>").attr(id: "display")
      @nextNumber = 1
      @you = $("<span>").attr(id: "you")
      @challenger = $("<span>").attr(id: "challenger")
      @yourScore = 0
      @challengersScore = 0
      @initView()
      
    initView: ->
      numberTable = $("<table>")
      for number, index in @numbers
        tr = $("<tr>") if index % 5 == 0
        td = $("<td>").attr(id: number).html(number)
        tr.append(td)
        numberTable.append(tr) if index % 5 == 4
      
      score = $("<ul>").attr(id: "score")
      yourList = $("<li>").addClass("pink")
      yourName = $("<span>").html("You: ")
      @you.html(@yourScore)
      challengersList = $("<li>").addClass("blue")
      challengersName = $("<span>").html("Challenger: ")
      @challenger.html(@challengersScore)
      
      @display.html(@nextNumber)
      
      score.append(yourList.append(yourName).append(@you)).append(challengersList.append(challengersName).append(@challenger))
      @game.append(@display).append(numberTable).append(score)
      
    changeNumber: (numberWithPlayer) -> 
      number = numberWithPlayer.number
      player = numberWithPlayer.player
      
      $("##{number}").addClass(player)
      
      if player == 'you'
        @yourScore++
        @you.html(@yourScore)
      else
        @challengersScore++
        @challenger.html(@challengersScore)
    
      @nextNumber++
      console.log @nextNumber
      
      if @nextNumber > 25
        @finishGame()
        return
      else
        @display.html(@nextNumber)
    
    finishGame: ->
      if @yourScore > @challengersScore
        @display.html('You Win !')
      else
        @display.html('You Lose ...')
      
    find: (id) ->
      @numbers.indexOf(id)    


##### Variables #####
  managementView = new ManagementView
  gameView = null
  socket = io.connect()


##### Socket Events #####
  socket.on "connect", ->

  socket.on "count-change", (count) ->
    managementView.countChange(count)

  socket.on "game-start", (numbers) ->
    gameView = new GameView(numbers)
    managementView.gameStart()
  
  socket.on "click-number", (numberWithPlayer) ->
    gameView.changeNumber(numberWithPlayer)


##### View Events #####   
  $("#disconnectBtn").click ->
    socket.disconnect()
    managementView.disconnect()
  $("#startBtn").click ->
    socket.emit "game-start"
  $("td").live 'click', ->
    number = parseInt($(this).html())
    if number == gameView.nextNumber
      socket.emit "click-number", (number)