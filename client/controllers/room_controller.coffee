intervalId = null

# heartbeat
Meteor.startup ->
  Deps.autorun ->
    if Session.get "roomId"
      unless intervalId
        App.call "updateActivity" if App?
        intervalId = Meteor.setInterval ->
          App.call "updateActivity" if App?
        , 5000
    else
      if intervalId
        Meteor.clearInterval intervalId
        intervalId = null

Template.room.room = ->
  Session.get "currentRoom"

Template.room_joined.room = ->
  Session.get "currentRoom"

Template.room.showCountdown = ->
  Session.get("timeLeft") > 0

Template.room.isOwner = ->
  currentRoom = Session.get "currentRoom"
  return false unless currentRoom
  currentRoom.owner == Meteor.userId()

Template.room.players = ->
  currentRoom = Session.get "currentRoom"
  return [] unless currentRoom
  list = Meteor.users.find({_id: {"$in": currentRoom.players}}).fetch()
  _.map list, (user) ->
    displayName = "Anonymous"
    displayName = user.profile.name if user.profile?.name?
    displayName = user.emails[0].address if user.emails?.length > 0 and user.emails[0].address?
    if user._id == Meteor.userId()
      displayName += " (me)"
    {_id: user._id, displayName: displayName, lastActivity: user.lastActivity}


Template.room.events
  "click .make-public": (e) ->
    App.call "makePublic", true, (err, data) ->
      throw err if err
  "click .make-private": (e) ->
    App.call "makePublic", false, (err, data) ->
      throw err if err
  "click .join-room": (e) ->
    roomId = Session.get "roomId"
    
    if Meteor.user()?
      Meteor.call "joinRoom", roomId, (err, data) ->
        Meteor.Router.to "/room/join/#{roomId}"
    else
      Meteor.Router.to "/login"