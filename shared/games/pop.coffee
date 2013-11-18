BUBBLE_DURATION = 3

class @Wiblit.Pop extends @Wiblit.Game
  constructor: (@el) ->
    super @el
    @duration = 10
    @title = "Pop!"
    @description = "Pop the blue bubbles! Don't pop the red ones."
  
  @compareTwoResults: (result1, result2) ->
    #console.log "is #{result1.points} higher than #{result2.points}?"
    return -1 if result1.points > result2.points
    return 1
  
  start: =>
    #console.log "START Pop!"
    super()
    @canvas = $("<canvas>")
    @ctx = @canvas[0].getContext "2d"
    @w = window.innerWidth
    @h = window.innerHeight
    @canvas.css
      width: "#{@w}px"
      height: "#{@h}px"
      position: "absolute"
      top: "0px"
      left: "0px"
    @canvas[0].width = @w
    @canvas[0].height = @h
    
    @bubbles = []
    window.bubbles = @bubbles
    bubbleCount = 20
    for i in [0..bubbleCount]
      t = Math.random() * (@duration-1)
      bdur = BUBBLE_DURATION + (1-(bubbleCount-i)/bubbleCount)
      @bubbles.push new Bubble @ctx, Math.random(), Math.random(), Date.now() + t*1000, Date.now() + (t+bdur)*1000
    
    touchEvent = "mousedown"
    touchEvent = "touchstart" if window.ontouchstart
    
    #console.log "touchEvent", touchEvent
    
    @canvas.bind touchEvent, (e) =>
      _.each @bubbles, (bubble) =>
        if bubble.testHit e.offsetX, e.offsetY, window.innerWidth, window.innerHeight
          #console.log "Hit a bubble!"
          bubble.popped = true
          if bubble.isTarget
            @points++
          else
            @points -= 5
        else
          #console.log "Nope!"
    #bubble.testHit
    
    @render()
    @el.append @canvas
  
  finish: =>
    @value = @points
    super()
  
  render: =>
    return unless @canvas and @ctx
    
    @ctx.clearRect 0, 0, @canvas[0].width, @canvas[0].height
    @w = window.innerWidth
    @h = window.innerHeight
    @canvas[0].width = @w
    @canvas[0].height = @h
    
    for bubble in @bubbles
      bubble.render window.innerWidth, window.innerHeight
    
    unless @finished
      window.requestAnimationFrame @render

class Bubble
  constructor: (@ctx, @x, @y, @startTime, @endTime) ->
    @peakTime = 0.8
    @isTarget = if Math.random() > 0.3 then true else false
    if @isTarget
      @color =
        r: 0
        g: 255
        b: 0
    else
      @color =
        r: 255
        g: 0
        b: 0
    @popped = false
    @rad = 0
  
  testHit: (x, y, w, h) =>
    _x = @x*w
    _y = @y*h
    #if @rad > 0
    #  console.log "testHit", x, y, w, h, _x, _y, @rad
    dist = Math.sqrt Math.pow(x-_x,2) + Math.pow(y-_y,2)
    dist < @rad
  
  render: (w, h) =>
    @rad = 0
    return if @popped
    return if Date.now() > @endTime
    return if Date.now() < @startTime
    
    time = (Date.now()-@startTime) / (@endTime-@startTime)
    
    maxSize = if w < h then w else h
    maxSize *= 0.1
    
    if time < @peakTime
      p = (time/@peakTime)
    else
      p = 1 - (time-@peakTime)/(1-@peakTime)
    @rad = p*maxSize
    
    a = p
    @ctx.beginPath()
    @ctx.fillStyle = "rgba(#{@color.r}, #{@color.g}, #{@color.b}, #{a})"
    @ctx.arc @x*w, @y*h, @rad, 0, 2*Math.PI
    @ctx.fill()
