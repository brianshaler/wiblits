class @Wiblit.Roshambo extends @Wiblit.Game
  @moves =
    rock:
      beats: (other) -> other == "scissors"
    paper:
      beats: (other) -> other == "rock"
    scissors:
      beats: (other) -> other == "scissors"
  
  constructor: (@el) ->
    super @el
  
  @compareTwoResults: (result1, result2) ->
    console.log "does #{result1.selection} beat #{result2.selection}?"
    return -1 if Wiblit.Roshambo.moves[result1.selection]?.beats(result2.selection)
    return 1
  
  start: ->
    super()
    buttons = ["rock", "paper", "scissors"]
    
    _.each buttons, (button) =>
      b = $("<button>")
      b.addClass "game-select"
      b.attr "data-value", button
      b.html button
      @el.append b
    $(".game-select", @el).click (e) =>
      val = $(e.target).attr "data-value"
      @selection = val
      @finish()
