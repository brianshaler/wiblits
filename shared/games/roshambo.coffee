class @Wiblit.Roshambo extends @Wiblit.Game
  @moves =
    rock:
      beats: (other) -> other == "scissors"
    paper:
      beats: (other) -> other == "rock"
    scissors:
      beats: (other) -> other == "paper"
  
  constructor: (@el) ->
    super @el
    @duration = 11
  
  @compareTwoResults: (result1, result2) ->
    return 1 if result1.selection == ""
    return -1 if result2.selection == ""
    #console.log "is #{result1.points} higher than #{result2.points}?"
    return -1 if result1.points > result2.points
    return 1
  
  @onFinish: (results) ->
    #console.log "RESULTS", results
    #return results
    _.each results, (result, key) ->
      result.points = _.reduce results, (memo, otherResult) ->
        if Wiblit.Roshambo.moves[result.selection]?.beats(otherResult.selection)
          #console.log "#{result.selection} beats #{otherResult.selection}"
          memo+1
        else
          memo
      , 0
      #console.log "result"
      #console.log result
      result.value = "#{result.points} (#{result.selection})"
      result.value = "FAIL" if result.selection == ""
      result
    results
  
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
      #console.log "finish!"
      @value = @selection
      @finish()
