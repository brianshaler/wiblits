Future = Npm.require "fibers/future"

Meteor.methods
  startGame: (gameId) ->
    check gameId, String
    Games.update _id: gameId,
      $set:
        started: game.started
  
  getFriends: ->
    if !@userId
      return false
    
    friends = Friends.findOne
      userId: @userId
    
    if friends and friends.lastUpdate.getTime() > Date.now()-86400*1000
      console.log "already have friends"
      return friends.friends
    
    fut = new Future()
    
    token = Meteor.user().services.twitter.accessToken
    secret = Meteor.user().services.twitter.accessTokenSecret
    
    T = GetTwitter token, secret
    T.get "friends/list", {count: 200}, (err, data) =>
      throw err if err
      console.log data
      
      unless friends
        friends = _.clone FriendsSchema
        friends.userId = @userId
        Friends.insert friends
      
      _.each data.users, (user) ->
        unless (_.some friends.friends, (friend) -> friend.id_str == user.id_str)
          friends.friends.push user
      
      Friends.update userId: @userId,
        $set:
          friends: friends.friends
      console.log "now i have friends"
      fut.return friends.friends
    return fut.wait()
