COUNTDOWN = 6
Session.set "startedCountdown", null

checkCountdown = ->
  startedCountdown = Session.get "startedCountdown"
  
  if !startedCountdown
    startedCountdown = Date.now()
    Session.set "startedCountdown", startedCountdown
  
  timeLeft = COUNTDOWN - (Date.now()-startedCountdown)
  
  if timeLeft > 0
    Meteor.setTimeout checkCountdown, 100
  else
    Session.set "starting", false
    Session.set "playing", true
    Session.set "startedAt", new Date()

Deps.autorun ->
  gameId = Session.get "gameId"
  return unless gameId
  game = Game.findOne gameId
  
  # return if currently playing
  unless game.started and !game.finished
    Session.set "timeLeft", 0
    return
  
  checkCountdown()
  
  Session.set "timeLeft", timeLeft
  Game.findOne gameId

Template.starting.timeLeft = ->
  Math.round 0.001 * Session.get "timeLeft"
