Template.waiting_room.isOwner = ->
  Template.game.isOwner()

Template.waiting_room.players = ->
  Template.game.players()
