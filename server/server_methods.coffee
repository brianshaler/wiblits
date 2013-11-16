Meteor.methods
  startGame: (gameId) ->
    check gameId, String
    game = Game.findOne gameId
    if !game
      throw new Meteor.Error 404, "Game not found"
    game.started = true
    Game.update _id: gameId,
      $set:
        started: game.started
  
