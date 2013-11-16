@Player = new Meteor.Collection "player"

@Player.allow
  insert: () -> false
  update: () -> false
  remove: () -> false

@PlayerSchema =
  userId: ""
  friends: []
  lastUpdated: new Date()
