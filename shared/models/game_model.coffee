@Game = new Meteor.Collection "game"

@Game.allow
  insert: () -> false
  update: () -> false
  remove: () -> false

@GameSchema =
  room: ""
  started: false
  finished: false
  players: []
  results: {}
  createdAt: new Date()
