
Meteor.methods
  createRoom: ->
    room = _.clone RoomSchema
    room.owner = @userId
    room.players = [@userId]
    room.public = true
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
  
  gameProgress: (roomId, progress) ->
    check roomId, String
    
    room = Room.findOne roomId
    if !room
      throw new Meteor.Error 404, "Room not found"
    if !room.game
      throw new Meteor.Error 404, "Game not found"
    game = Game.findOne room.game
    
    # this is a race condition waiting to happen...
    game.results[@userId] = progress
    
    game.results = Wiblit[game.name].sortResults(game.results)
    
    Game.update _id: game._id,
      $set:
        results: game.results
  
  gameFinish: (roomId, progress) ->
    check roomId, String
    
    room = Room.findOne roomId
    if !room
      throw new Meteor.Error 404, "Room not found"
    if !room.game
      throw new Meteor.Error 404, "Game ID not found"
    game = Game.findOne room.game
    if !game
      throw new Meteor.Error 404, "Game not found"
    
    # this is a race condition waiting to happen...
    game.results[@userId] = progress
    game.results[@userId].finished = true
    
    unfinished = _.find game.players, (player) ->
      !game.results[player]? or game.results[player].finished != true
    
    unless unfinished # wrap up game
      game.inProgress = false
      game.finished = true
    
    #console.log "saving results #{room.game}", game
    Game.update _id: game._id,
      $set:
        results: game.results
        inProgress: game.inProgress
        finished: game.finished
    
    unless unfinished # wrap up room
      #console.log game.results
      results = Wiblit[game.name].onFinish game.results
      resultsList = _.map results, (result, key) ->
        obj = _.clone result
        obj.displayName = UserHelper.getUserName Meteor.users.findOne key
        obj
      room.results = Wiblit[game.name].sortResults(resultsList)
      room.inProgress = false
      room.finished = true
      Room.update _id: room._id,
        $set:
          results: room.results
          inProgress: room.inProgress
          finished: room.finished
  
  updateActivity: ->
    return unless @userId
    
    Meteor.users.update _id: @userId,
      $set:
        lastActivity: new Date()
