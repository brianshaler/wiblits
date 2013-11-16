@Twitter = new Meteor.Collection "twitter"

@Twitter.allow
  insert: () -> false
  update: () -> false
  remove: () -> false

@TwitterSchema =
  userId: ""
  following: []
  lastUpdated: new Date()
