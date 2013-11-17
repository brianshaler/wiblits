@Wiblit = Wiblit ? {}

class @Wiblit.Game
  constructor: (@el) ->
    @points = 0
    @progress = 0
    @lives = 0
    @selection = ""
    @started = false
  
  @sortResults: (results) ->
    results.sort @compareTwoResults
  
  @compareTwoResults: (result1, result2) ->
    console.log "Game.compareTwoResults"
    result1 > result2
  
  start: ->
    Session.set "finishedPlaying", false
  
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
    Session.set "finishedPlaying", true
    status =
      points: @points
      progress: @progress
      lives: @lives
      selection: @selection
    App.call "gameFinish", status, (err, data) ->
      throw err if err

