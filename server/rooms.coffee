ACTIVITY_TIMEOUT = 20 # seconds
COUNTDOWN = 6

Meteor.startup ->
  Meteor.setInterval ->
    startScheduledGames()
    endFinishedGames()
    rooms = Room.find({$where: "this.players.length > 1"}).fetch()
    _.each rooms, (room) ->
      pruneActiveUsers room
      scheduleNewGame room
    #console.log "rooms to prune: #{rooms.length}"
  , 1000


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
  if !room.starting and !room.inProgress and room.players.length > 1
    #console.log "Start game! #{room._id} (in 6 seconds)"
    Room.update _id: room._id,
      $set:
        starting: true
        startAt: new Date Date.now()+COUNTDOWN*1000

startScheduledGames = ->
  # Create a game and start it if scheduled to start
  rooms = Room.find({starting: true, inProgress: false, startAt: {$lt: new Date()}}).fetch()
  _.each rooms, (room) ->
    game = _.clone GameSchema
    _.extend game, Games[Math.floor Math.random()*Games.length]
    game.roomId = room._id
    game.players = room.players
    gameId = Game.insert game
    #console.log "Creating a game for room #{room._id} (#{gameId})"
    
    duration = 60
    duration = game.duration if game.duration
    duration += 10
    
    Room.update _id: room._id,
      $set:
        inProgress: true
        starting: false
        game: gameId
        finishAt: new Date Date.now()+duration*1000
        finished: false
        results: []

endFinishedGames = ->
  # Create a game and start it if scheduled to start
  rooms = Room.find({finished: false, finishAt: {$lt: new Date()}}).fetch()
  _.each rooms, (room) ->
    game = Game.findOne room.game
    
    #room.results = Wiblit[game.name].sortResults(game.results)
    #console.log "Okay, #{room._id} is actually starting now"
    Room.update _id: room._id,
      $set:
        inProgress: false
        finished: true
