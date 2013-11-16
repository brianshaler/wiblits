
Meteor.publish "room", (roomId) ->
  Room.findOne roomId

Meteor.publish "rooms", () ->
  q = [{public: true}]
  if @userId
    check @userId, String
    q.push players: @userId
    q.push owner: @userId
  where =
    started: false
    $or: q
  Room.find where,
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

