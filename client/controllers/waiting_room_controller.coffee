Template.waiting_room.room = ->
  Template.room.room()

Template.waiting_room.isOwner = ->
  Template.room.isOwner()

Template.waiting_room.players = ->
  Template.room.players()

Template.waiting_room.events
  "click .start-playing": (e) ->
    App.call "startPlaying", (err, data) ->
      throw err if err
      console.log "room started?"
  "click .make-public": (e) ->
    console.log "make-public"
    App.call "makePublic", true, (err, data) ->
      throw err if err
  "click .make-private": (e) ->
    console.log "make-private"
    App.call "makePublic", false, (err, data) ->
      throw err if err
  "click .join-room": (e) ->
    roomId = Session.get "roomId"
    Meteor.call "joinRoom", roomId, (err, data) ->
      Meteor.Router.to "/room/#{roomId}"
