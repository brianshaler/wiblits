@Friends = new Meteor.Collection "friends"

@Friends.allow
  insert: () -> false
  update: () -> false
  remove: () -> false

@FriendsSchema =
  userId: ""
  friends: []
  lastUpdated: new Date()
