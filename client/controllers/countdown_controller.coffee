
Meteor.startup ->
  Deps.autorun ->
    Session.get "startedCountdown"
    Session.get "timeLeft"
    room = Session.get "currentRoom"
    return unless room
    

Template.countdown.timeLeft = ->
  timeLeft = Math.floor Session.get "timeLeft"
  timeLeft = 0 unless timeLeft > 0
  timeLeft
