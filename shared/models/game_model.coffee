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

gameNames = ["Roshambo", "Pop", "HighNumber"]
games = []
gamesByName = {}

addGame = (name) ->
  wg = new Wiblit[name]()
  obj =
    name: name
    title: wg.title
    description: wg.description
    duration: wg.duration
  games.push obj
  gamesByName[name] = obj

Meteor.startup ->
  _.each gameNames, (name) -> addGame name

@Games = games
@GamesByName = gamesByName