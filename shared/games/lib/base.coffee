@Wiblit = Wiblit ? {}

class @Wiblit.Game
  constructor: (@el) ->
    @duration = 10
    @title = "Game Title"
    @description = "Game Description"
    
    @points = 0
    @progress = 0
    @lives = 0
    @selection = ""
    @started = false
    @value = ""
    @timeoutId = null
  
  @sortResults: (results) ->
    results.sort @compareTwoResults
  
  @compareTwoResults: (result1, result2) ->
    console.log "Game.compareTwoResults"
    result1 > result2
  
  start: ->
    Session.set "finishedPlaying", false
    if @timeoutId
      Meteor.clearTimeout @timeoutId
    @timeoutId = Meteor.setTimeout =>
      @finish()
    , @duration*1000
  
  quit: ->
    #nothing?
  
  sendStatus: ->
    status =
      points: @points
      progress: @progress
      lives: @lives
      selection: @selection
      value: @value
    App.call "gameProgress", status, (err, data) ->
      throw err if err
  
  finish: ->
    Session.set "finishedPlaying", true
    status =
      points: @points
      progress: @progress
      lives: @lives
      selection: @selection
      value: @value
    App.call "gameFinish", status, (err, data) ->
      throw err if err

