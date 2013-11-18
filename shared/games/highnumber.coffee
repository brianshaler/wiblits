class @Wiblit.HighNumber extends @Wiblit.Game
  constructor: (@el) ->
    super @el
    @duration = 4
    @title = "High Number"
    @description = "Click the highest number"
  
  @compareTwoResults: (result1, result2) ->
    #console.log "is #{result1.points} higher than #{result2.points}?"
    return -1 if result1.points > result2.points
    return 1
  
  start: ->
    return if @started == true
    super()
    @started = true
    buttons =
      one: 1
      ten: 10
      fifty: 50
    
    div = $('<div class="highnumber">')
    div.append '<h2>Select the Highest Number</h2>'
    
    _.each buttons, (value, key) =>
      b = $("<button>")
      b.addClass "btn btn-default game-select"
      b.attr "data-value", value
      b.html key
      div.append b
    
    @el.append div
    
    $(".game-select", @el).click (e) =>
      val = $(e.target).attr "data-value"
      @points = val
      @selection = $(e.target).html()
      @value = @points
      @finish()
