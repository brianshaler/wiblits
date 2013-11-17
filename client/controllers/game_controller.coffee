gameRendered = false

Template.game.rendered = ->
  game = Game.findOne Session.get "gameId"
  if game and !gameRendered
    gameRendered = true
    wg = new Wiblit[game.name]($(".game-container"))
    wg.start()

Template.game.destroyed = ->
  gameRendered = false

Template.game.playerFinished = ->
  Session.get "finishedPlaying"

Template.game.gameFinished = ->
  finished = false
  game = Game.findOne Session.get "gameId"
  if game?.finished then true else false
#  if game?.inProgress and !
