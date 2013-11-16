Meteor.methods
  createGame: ->
    game = _.clone GameSchema
    game.owner = @userId
    game.players = [@userId]
    Game.insert game
  joinGame: (gameId) ->
    check gameId, String
    
    game = Game.findOne gameId
    if !game
      throw new Meteor.Error 404, "Game not found"
    
    game.players.push @userId
    
    Game.update _id: gameId,
      $set:
        players: game.players
