COUNTDOWN = 6
timeoutId = null

Session.set "startedCountdown", null

checkCountdown = ->
  return unless Session.get "countingDown"
  if timeoutId
    Meteor.clearTimeout timeoutId
  #console.log "checkCountdown"
  startedCountdown = Session.get "startedCountdown"
  
  if !startedCountdown
    startedCountdown = Date.now()
    Session.set "startedCountdown", startedCountdown
  
  timeLeft = COUNTDOWN - (Date.now()-startedCountdown)/1000
  #console.log "timeLeft", timeLeft
  
  if timeLeft > -1
    Session.set "timeLeft", timeLeft
    #console.log "check again"
    timeoutId = Meteor.setTimeout checkCountdown, 1000
  else
    #Session.set "timeLeft", null
    #Session.set "startedCountdown", null
    Session.set "countingDown", false
    Session.set "starting", false
    Session.set "playing", true
    Session.set "startedAt", new Date()

Meteor.startup ->
  Deps.autorun ->
    Session.get "startedCountdown"
    Session.get "timeLeft"
    room = Session.get "currentRoom"
    return unless room
    
    if !timeoutId
      checkCountdown()

Template.starting.timeLeft = ->
  Math.floor Session.get "timeLeft"
