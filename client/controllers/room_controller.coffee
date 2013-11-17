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


WAITING = "waiting"
STARTING = "starting"
PLAYING = "playing"

COUNTDOWN = 6
timeoutId = null
Session.set "startedCountdown", null
Session.set "timeLeft", null
Session.set "isPlayer", false

# Room state
Session.set "roomState", WAITING
setState = (newState) ->
  currentState = Session.get "roomState"
  console.log "setState: #{newState} (#{currentState})"
  if newState == PLAYING and currentState != PLAYING and currentState != STARTING
    newState = STARTING
  if newState == STARTING and currentState != STARTING
    console.log "start countdown? #{Session.get("timeLeft")}"
    unless typeof Session.get("timeLeft") == "number"
      startCountdown()
  if newState == PLAYING
    Session.set "timeLeft", null
  #if newState == PLAYING and currentState != PLAYING
  console.log "Setting current state", newState
  Session.set "roomState", newState

startCountdown = ->
  console.log "starting countdown"
  Session.set "startedCountdown", Date.now()
  Session.set "timeLeft", 6
  timeoutId = Meteor.setTimeout checkCountdown, 100

checkCountdown = ->
  return unless Session.get("roomState") == STARTING
  if timeoutId
    Meteor.clearTimeout timeoutId
  startedCountdown = Session.get "startedCountdown"
  
  if !startedCountdown
    startedCountdown = Date.now()
    Session.set "startedCountdown", startedCountdown
  
  timeLeft = COUNTDOWN - (Date.now()-startedCountdown)/1000
  
  if timeLeft > -1
    Session.set "timeLeft", timeLeft
    timeoutId = Meteor.setTimeout checkCountdown, 100
  else
    Session.set "timeLeft", null
    Session.set "startedAt", new Date()


Session.set "isPlayer", false
Meteor.startup ->
  Deps.autorun ->
    room = Room.findOne Session.get "roomId"
    return unless room
    
    Session.set "currentRoom", room
    game = null
    if room.game
      Session.set "gameId", room.game
      game = Game.findOne room.game
    else
      Session.set "gameId", null
    
    return unless game
    
    currentState = Session.get "roomState"
    if room.starting and currentState == WAITING
      setState STARTING
    if Session.get("timeLeft") < 0
      setState PLAYING
    Session.set "isPlayer", true if Meteor.userId() and _.find game.players, (player) -> player == Meteor.userId()

Template.room.room = ->
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
    displayName = UserHelper.getUserName user
    
    if user._id == Meteor.userId()
      displayName += " (me)"
    {_id: user._id, displayName: displayName, lastActivity: user.lastActivity}



Template.room.stateWaiting = ->
  WAITING == Session.get("roomState") or !Session.get("isPlayer")
Template.room.stateStarting = ->
  STARTING == Session.get("roomState") and Session.get("isPlayer")
Template.room.statePlaying = ->
  PLAYING == Session.get("roomState") and Session.get("isPlayer")

Template.room.startingAndJoined = ->
  return false

Template.room.events
  "click .join-room": (e) ->
    roomId = Session.get "roomId"
    
    if Meteor.user()?
      Meteor.call "joinRoom", roomId, (err, data) ->
        Meteor.Router.to "/room/#{roomId}"
    else
      Meteor.Router.to "/login"