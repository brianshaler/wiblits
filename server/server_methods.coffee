Meteor.methods
  startPlaying: (roomId) ->
    check roomId, String
    room = Room.findOne roomId
    if !room
      throw new Meteor.Error 404, "Room not found"
    room.started = true
    Room.update _id: roomId,
      $set:
        started: room.started
  
