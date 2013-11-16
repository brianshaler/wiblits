
Meteor.publish "game", (gameId) ->
  Game.findOne gameId

Meteor.publish "games", () ->
  q = [{started: false}]
  if this.userId
    check this.userId, String
    q.push players: this.userId
    q.push owner: this.userId
  Game.find
    $or: q
    {
      sort:
        createdDate: -1
      limit: 10
    }

Meteor.publish "friends", () ->
  if !@userId
    throw new Meteor.Error 403, "Must be logged in to retrieve friends"
  Players.find
    friends: @userId
    {
      sort:
        lastUpdated: -1
      limit: 10
    }

Meteor.publish "allUsers", () ->
  x = 1
  Meteor.users.find {},
    {
      sort:
        createdAt: -1
      limit: 10
    }

