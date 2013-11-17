@Wiblit = Wiblit ? {}

class @Wiblit.Game
  constructor: (@el) ->
    @points = 0
    @progress = 0
    @lives = 0
    @selection = ""
  
  start: ->
    
  
  quit: ->
    #nothing?
  
  sendStatus: ->
    status =
      points: @points
      progress: @progress
      lives: @lives
      selection: @selection
    App.call "gameProgress", status, (err, data) ->
      throw err if err
  
  finish: ->
    status =
      points: @points
      progress: @progress
      lives: @lives
      selection: @selection
    App.call "gameFinish", status, (err, data) ->
      throw err if err

