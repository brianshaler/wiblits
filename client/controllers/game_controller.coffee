gameRendered = false

WAITING = "waiting"
STARTING = "starting"
PLAYING = "playing"

gameState = (newState) ->
  if newState == STARTING and Session.get("gameState") == WAITING
    Session.set "timeLeft", 6
  Session.set "gameState", newState

# Game state
Session.set "gameState", "waiting"

Meteor.startup ->
  Deps.autorun ->
    game = Game.findOne Session.get "gameId"
    if game
      
    else
      gameState "waiting"
    


findGame = (gameId) ->
  

Scoring =
  
  sortResults: (game, results) ->
    

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

Template.game.resultsList = ->
  game = Game.findOne Session.get "gameId"
  results = []
  if game
    results = _.map game.results, (result, _id) ->
      console.log "User by id #{_id}"
      console.log Meteor.users.findOne(_id)
      user = Meteor.users.findOne _id
      user.displayName = UserHelper.getUserName user
      {user: user, value: result.selection}
  results
  
#  if game?.inProgress and !
