ACTIVITY_TIMEOUT = 20 # seconds
COUNTDOWN = 6

Meteor.startup ->
  Meteor.setInterval ->
    startScheduledGames()
    #endFinishedGames()
    rooms = Room.find({$where: "this.players.length > 1"}).fetch()
    _.each rooms, (room) ->
      pruneActiveUsers room
      scheduleNewGame room
    #console.log "rooms to prune: #{rooms.length}"
  , 2000


# prune inactive users in waiting area
pruneActiveUsers = (room) ->
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

# Schedule game to start in {COUNTDOWN} seconds if enough players
scheduleNewGame = (room) ->
  if !room.starting and room.players.length > 1
    console.log "Start game! #{room._id} (in 6 seconds)"
    Room.update _id: room._id,
      $set:
        starting: true
        startAt: new Date Date.now()+COUNTDOWN*1000

startScheduledGames = ->
  # Create a game and start it if scheduled to start
  rooms = Room.find({inProgress: false, startAt: {$lt: new Date()}}).fetch()
  _.each rooms, (room) ->
    game = _.clone GameSchema
    _.extend game, Games[0]
    game.roomId = room._id
    game.players = room.players
    gameId = Game.insert game
    
    console.log "Okay, #{room._id} is actually starting now"
    Room.update _id: room._id,
      $set:
        inProgress: true
        game: gameId

endFinishedGames = ->
  # Create a game and start it if scheduled to start
  rooms = Room.find({inProgress: false, startAt: {$lt: new Date()}}).fetch()
  _.each rooms, (room) ->
    game = _.clone GameSchema
    _.extend game, Games[0]
    game.roomId = room._id
    game.players = room.players
    gameId = Game.insert game
    
    console.log "Okay, #{room._id} is actually starting now"
    Room.update _id: room._id,
      $set:
        inProgress: true
        game: gameId