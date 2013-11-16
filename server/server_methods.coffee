
Meteor.setInterval ->
  rooms = Room.find({players: {$size: {$gt: 1}}}).fetch()
  _.each rooms, (room) ->
    
    # prune inactive users in waiting area
    if !room.inProgress
      users = Meteor.users.find({_id: {$in: room.players}}).fetch()
      activeUsers = []
      _.each users, (user) ->
        if user.lastActivity.getTime() > Date.now()-ACTIVITY_TIMEOUT*1000
          activeUsers.push user._id
      if activeUsers.length < room.players.length
        Room.update _id: room._id,
          $set:
            players: activeUsers
    if !room.inProgress and room.players.length > 1
      Room.update _id: room._id,
        $set:
          inProgress: true
          
  #console.log "rooms to prune: #{rooms.length}"
, 2000



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
  nextGame: (roomId) ->
