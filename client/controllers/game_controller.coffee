#currentGame = null

Template.game.game = ->
  currentGame = Game.findOne Session.get "gameId"
  Session.set "currentGame", currentGame
  currentGame

Template.game.isOwner = ->
  currentGame = Session.get "currentGame"
  return false unless currentGame
  currentGame.owner == Meteor.userId()

Template.game.players = ->
  currentGame = Session.get "currentGame"
  return [] unless currentGame
  list = Meteor.users.find({_id: {"$in": currentGame.players}}).fetch()
  _.map list, (user) ->
    displayName = "Anonymous"
    displayName = user.profile.name if user.profile?.name?
    displayName = user.emails[0].address if user.emails?.length > 0 and user.emails[0].address?
    if user._id == Meteor.userId()
      displayName += " (me)"
    {_id: user._id, displayName: displayName}

Template.game.events
  "click .start-game": (e) ->
    gameId = Session.get "gameId"
    App.call "startGame", (err, data) ->
      throw err if err
      console.log "game started?"
