Template.game.rendered = ->
  game = Game.findOne Session.get "gameId"
  if game
    console.log "game.rendered OK"
    wg = new Wiblit[game.name]($(".game-container"))
    wg.start()

Template.game.playerFinished = ->
  Session.get "finishedPlaying"

Template.game.gameFinished = ->
  finished = false
  game = Game.findOne Session.get "gameId"
  if game?.finished then true else false

Template.game.resultsList = ->
  room = Session.get "currentRoom"
  return [] unless room?.results?.length > 0
  room.results

