Template.waiting_room.isOwner = ->
  Template.room.isOwner()

Template.waiting_room.players = ->
  Template.room.players()

Template.waiting_room.events
  "click .start-playing": (e) ->
    roomId = Session.get "roomId"
    App.call "startPlaying", (err, data) ->
      throw err if err
      console.log "room started?"
