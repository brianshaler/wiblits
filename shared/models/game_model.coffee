@Game = new Meteor.Collection "game"

@Game.allow
  insert: () -> false
  update: () -> false
  remove: () -> false

@GameSchema =
  roomId: ""
  started: false
  finished: false
  players: []
  results: {}
  createdAt: new Date()


defaultGame =
  isSelect: false
  isCanvas: false
  name: ""
  description: "description"

games = []
addGame = (obj) ->
  games.push _.extend _.clone(defaultGame), obj

addGame
  name: "Roshambo"
  isSelect: true
#addGame
#  name: ""
#  isSelect: true

@Games = games