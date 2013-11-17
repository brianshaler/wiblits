###
Accounts.onCreateUser (options, user) ->
  user.friends = []
  user.lastActivity = new Date()
  # We still want the default hook's 'profile' behavior.
  user.profile = options.profile if options.profile
  user
###

Meteor.methods
  createRoom: ->
    room = _.clone RoomSchema
    room.owner = @userId
    room.players = [@userId]
    Room.insert room
  
  makePublic: (roomId, makePublic) ->
    check makePublic, Boolean
    
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
    room.inRoom.push @userId
    
    room.players = _.uniq room.players
    room.inRoom = _.uniq room.inRoom
    
    Room.update _id: roomId,
      $set:
        players: room.players
        inRoom: room.inRoom
  
  updateActivity: ->
    return unless @userId
    
    Meteor.users.update _id: @userId,
      $set:
        lastActivity: new Date()
