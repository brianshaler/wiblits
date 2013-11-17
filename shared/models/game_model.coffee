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
  duration: 60

games = []
addGame = (obj) ->
  games.push _.extend _.clone(defaultGame), obj

addGame
  name: "HighNumber"
  isSelect: true
  duration: 10
addGame
  name: "Roshambo"
  isSelect: true
  duration: 10



#addGame
#  name: ""
#  isSelect: true

@Games = games