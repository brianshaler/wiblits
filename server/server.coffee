publicUserFields =
  "emails.address": 1
  "profile.name": 1
  lastActivity: 1

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
  opt =
    limit: 10
    sort:
      createdDate: -1
  Room.find where, opt

Meteor.publish "allUsers", () ->
  opt =
    fields: publicUserFields
    limit: 10
    sort:
      createdAt: -1
  Meteor.users.find {}, opt

Meteor.startup ->
  Accounts.loginServiceConfiguration.remove
    service: "twitter"
  
  Accounts.loginServiceConfiguration.insert
    service: "twitter"
    consumerKey: "uM82UIJfUYqRTpsYBD8HBw"
    secret: "zBVnLQMt7fKFlO7AoC8Nk32tD8LMsJwrU0jn0HJ9Q"