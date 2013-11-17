class @Wiblit.Roshambo extends @Wiblit.Game
  constructor: (@el) ->
    super @el
  
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
