class @Wiblit.HighNumber extends @Wiblit.Game
  constructor: (@el) ->
    super @el
  
  @compareTwoResults: (result1, result2) ->
    console.log "does #{result1.points} higher than #{result2.points}?"
    return -1 if result1.points > result2.points
    return 1
  
  start: ->
    super()
    buttons =
      one: 1
      ten: 10
      fifty: 50
    
    _.each buttons, (value, key) =>
      b = $("<button>")
      b.addClass "game-select"
      b.attr "data-value", value
      b.html key
      @el.append b
    $(".game-select", @el).click (e) =>
      val = $(e.target).attr "data-value"
      @points = val
      @finish()
