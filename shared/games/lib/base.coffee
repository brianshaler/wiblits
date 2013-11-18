@Wiblit = Wiblit ? {}

class @Wiblit.Game
  constructor: (@el) ->
    @duration = 10
    @title = "Game Title"
    @description = "Game Description"
    
    @started = false
    @finished = false
    
    @points = 0
    @progress = 0
    @lives = 0
    @selection = ""
    @value = ""
    @timeoutId = null
  
  @sortResults: (results) ->
    results.sort @compareTwoResults
  
  @compareTwoResults: (result1, result2) ->
    console.log "Game.compareTwoResults"
    result1 > result2
  
  @onFinish: (results) -> results
  
  start: ->
    @startedAt = Date.now()
    Session.set "finishedPlaying", false
    if @timeoutId
      Meteor.clearTimeout @timeoutId
    @timeoutId = Meteor.setTimeout =>
      if !@finished
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
    return if @finished
    console.log "base, broadcast FINISH"
    @finished = true
    Session.set "finishedPlaying", true
    status =
      points: @points
      progress: @progress
      lives: @lives
      selection: @selection
      value: @value
    App.call "gameFinish", status, (err, data) ->
      throw err if err

