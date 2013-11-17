ACTIVITY_TIMEOUT = 20 # seconds
COUNTDOWN = 6

Meteor.startup ->
  Meteor.setInterval ->
    rooms = Room.find({inProgress: false, startAt: {$lt: new Date()}}).fetch()
    _.each rooms, (room) ->
      game = _.clone GameSchema
      game.roomId = room._id
      game.players = room.players
      gameId = Game.insert game
      
      Room.update _id: room._id,
        $set:
          inProgress: true
          game: gameId
    
    rooms = Room.find({$where: "this.players.length > 1"}).fetch()
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
      
      if !room.starting and room.players.length > 1
        console.log "Start game! #{room._id}"
        Room.update _id: room._id,
          $set:
            starting: true
            startAt: new Date Date.now()+COUNTDOWN*1000
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
