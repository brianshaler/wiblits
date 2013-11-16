Template.start.friends = ->
  [
    {name: "1"}
    {name: "2"}
    {name: "3"}
  ]

Template.start.allUsers = ->
  list = Meteor.users.find({_id: {"$ne": Meteor.userId()}}).fetch()
  _.map list, (user) ->
    displayName = "Anonymous"
    displayName = user.profile.name if user.profile?.name?
    displayName = user.emails[0].address if user.emails?.length > 0 and user.emails[0].address?
    if user._id == Meteor.userId()
      displayName += " (me)"
    {_id: user._id, displayName: displayName}

Template.start.openGames = ->
  games = Game.find({started: false}, {sort: {createdAt: -1}}).fetch()
  ownerIds = _.map games, (game) -> game.owner
  gamesByOwner = {}
  _.each games, (game) -> gamesByOwner[game.owner] = game._id unless gamesByOwner[game.owner]?
  
  list = Meteor.users.find({_id: {"$in": ownerIds}}).fetch()
  _.map list, (user) ->
    displayName = "Anonymous"
    displayName = user.profile.name if user.profile?.name?
    displayName = user.emails[0].address if user.emails?.length > 0 and user.emails[0].address?
    if user._id == Meteor.userId()
      displayName += " (me)"
    {_id: user._id, displayName: displayName, gameId: gamesByOwner[user._id]}

Template.start.events
  "click .start-game": (e) ->
    Meteor.call "createGame", (err, gameId) ->
      throw err if err
      Session.set "gameId", gameId
      #Session.set "showGame", true
      Meteor.Router.to "/game/#{gameId}"
  "click .join-game": (e) ->
    gameId = @._id
    Meteor.call "joinGame", gameId, (err, data) ->
      Meteor.Router.to "/game/#{gameId}"
