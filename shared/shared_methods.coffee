ACTIVITY_TIMEOUT = 20 # seconds

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
    
    room.inRoom = _.uniq room.inRoom
    
    Room.update _id: roomId,
      $set:
        players: room.players
  
  checkRoomStatus: (roomId) ->
    return unless @userId
    check roomId, String
    
    
  
  prune: (roomId) ->
    return unless @userId
    check roomId, String
    
    room = Room.findOne roomId
    if !room
      throw new Meteor.Error 404, "Room not found"
    
    users = Meteor.users.find({_id: {$in: room.players}}).fetch()
    activeUsers = []
    _.each users, (user) ->
      if user.lastActivity.getTime() > Date.now()-ACTIVITY_TIMEOUT*1000
        activeUsers.push user._id
    
    if activeUsers.length < room.players.length
      Room.update _id: roomId,
        $set:
          players: activeUsers
    Meteor.call "checkRoomStatus", roomId
  
  updateActivity: (roomId) ->
    return unless @userId
    check roomId, String
    
    room = Room.findOne roomId
    if !room
      throw new Meteor.Error 404, "Room not found"
    
    Meteor.users.update _id: @userId,
      $set:
        lastActivity: new Date()
    Meteor.call "prune", roomId
