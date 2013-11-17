Template.waiting_room.room = ->
  Session.get "currentRoom"

Template.waiting_room.isOwner = ->
  Template.room.isOwner()

Template.waiting_room.players = ->
  Template.room.players()

Template.waiting_room.hasJoined = ->
  hasJoined = false;
  currentRoom = Session.get "currentRoom"
  return [] unless currentRoom
  list = Meteor.users.find({_id: {"$in": currentRoom.players}}).fetch()
  _.map list, (user) ->
    if user._id is Meteor.userId()
      hasJoined = true
  hasJoined

Template.waiting_room.gameFinished = ->
  finished = false
  game = Game.findOne Session.get "gameId"
  if game?.finished then true else false

Template.waiting_room.events
  "click .start-playing": (e) ->
    App.call "startPlaying", (err, data) ->
      throw err if err
      console.log "room started?"
  "click .make-public": (e) ->
    App.call "makePublic", true, (err, data) ->
      throw err if err
  "click .make-private": (e) ->
    App.call "makePublic", false, (err, data) ->
      throw err if err
