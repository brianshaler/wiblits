Meteor.methods
  createRoom: ->
    room = _.clone RoomSchema
    room.owner = @userId
    room.players = [@userId]
    Room.insert room
  
  makePublic: (roomId, makePublic) ->
    check makePublic, Boolean
    
    console.log "makePublic " + (if makePublic then "true" else "false")
    
    room = Room.findOne roomId
    if !room
      throw new Meteor.Error 404, "Room not found"
    if room.owner != @userId
      throw new Meteor.Error 403, "You're not the owner"
    
    room.public = makePublic
    
    Room.update _id: roomId,
      $set:
        public: room.public
  
  joinRoom: (roomId) ->
    check roomId, String
    
    room = Room.findOne roomId
    if !room
      throw new Meteor.Error 404, "Room not found"
    
    room.players.push @userId
    
    Room.update _id: roomId,
      $set:
        players: room.players
