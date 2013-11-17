@initRoutes()

gameStarted = false
COUNTDOWN = 6

Meteor.autorun =>
  if !Session.get "showGame"
    Meteor.subscribe "rooms"
    Meteor.subscribe "allUsers"
  if Session.get "roomId"
    Meteor.subscribe "room", Session.get "roomId"
  if Session.get "gameId"
    Meteor.subscribe "game", Session.get "gameId"

class @App
  constructor: ->
    Meteor.startup =>
      Deps.autorun =>
        # hack
        lastUpdate = Session.set "lastUpdate", Date.now()
        
  # adds roomId as first parameter after method in Meteor.call()
  @call: () =>
    args = _.toArray arguments
    method = args.shift()
    args.unshift Session.get "roomId"
    args.unshift method
    Meteor.call.apply Meteor.call, args
  
  @loadRoom: (id) =>
    Session.set "roomLoading", true
    # access parameters in order a function args too
    handle = Meteor.subscribe "room", id, (err) =>
      #console.log "found..?"
      #Session.set id, true
      room = Room.findOne id
      if room
        #console.log "Showing room."
        Session.set "startedCountdown", null
        Session.set "timeLeft", null
        Session.set "isPlayer", false
        Session.set "roomState", "waiting"
        Session.set "roomId", id
        Session.set "showRoom", true
        Session.set "createError", null
      else
        #console.log "Okay, no room."
        Session.set "roomId", null
        Session.set "showRoom", false
        Session.set "createError", "Room not found"
      Session.set "roomLoading", false
    room = Room.findOne id
    if room
      Session.set "roomId", id
      Session.set "showRoom", true
      Session.set "roomLoading", false

app = @app = new @App()

Template.page.showRoom = -> Session.get "showRoom"

Deps.autorun =>
  body = $('body')
  body.removeClass("game")
  body.addClass("game")  if Session.get "showRoom"