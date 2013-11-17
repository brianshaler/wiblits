class @Wiblit.Pop extends @Wiblit.Game
  constructor: (@el) ->
    super @el
    @duration = 20
    @title = "Pop!"
    @description = "Pop the blue bubbles! Don't pop the red ones."
  
  @compareTwoResults: (result1, result2) ->
    console.log "is #{result1.points} higher than #{result2.points}?"
    return -1 if result1.points > result2.points
    return 1
  
  start: ->
    super()
    buttons = ["rock", "paper", "scissors"]
    @el.append '<h2>Roshambo</h2>'
    _.each buttons, (button) =>
      b = $("<button class='game-select btn btn-default'>")
      b.attr "data-value", button
      b.html button
      @el.append b
    $(".game-select", @el).click (e) =>
      val = $(e.target).attr "data-value"
      @selection = val
      console.log "finish!"
      @value = @selection
      @finish()
