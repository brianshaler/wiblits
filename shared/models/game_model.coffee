@Game = new Meteor.Collection "game"

@Game.allow
  insert: () -> false
  update: () -> false
  remove: () -> false

@GameSchema =
  owner: ""
  invites: []
  players: []
  started: false
  createdAt: new Date()
