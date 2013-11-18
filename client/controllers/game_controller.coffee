Session.set "timeRemaining", null

Meteor.setInterval ->
  updateTimeRemaining()
, 1000

Meteor.startup ->
  Meteor.autorun ->
    duration = Session.get "duration"
    startedAt = Session.get "gameStartedAt"
    updateTimeRemaining()

updateTimeRemaining = ->
  duration = Session.get("duration")
  startedAt = Session.get("gameStartedAt")
  left = 0
  if duration and startedAt
    left = duration - (Date.now()-startedAt)/1000
  
  if left > 0
    Session.set "timeRemaining", Math.floor(left)
  else
    Session.set "timeRemaining", null

gameRendered = false
Template.game_canvas.rendered = ->
  game = Game.findOne Session.get "gameId"
  if game and !gameRendered
    gameRendered = true
    $(".game-container").html ""
    wg = new Wiblit[game.name]($(".game-container"))
    wg.start()
    #console.log "game.rendered OK"

Template.game_canvas.gameId = ->
  Session.get "gameId"

Template.game_canvas.destroyed = ->
  gameRendered = false

Template.game.destroyed = ->
  gameRendered = false

Template.game.playerFinished = ->
  Session.get "finishedPlaying"

Template.game.gameFinished = ->
  finished = false
  game = Game.findOne Session.get "gameId"
  if game?.finished then true else false

Template.game.timeRemaining = ->
  Session.get "timeRemaining"
