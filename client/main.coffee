Meteor.subscribe "games"
Meteor.subscribe "allUsers"

@initRoutes()

class @App
  constructor: ->
    #@game = new GameController()
    
    Meteor.startup =>
      #root.viewport = new Viewporter "outer-container", fullHeightPortrait: false
      
      Session.set "twitterFriends", []
      
      # hack
      Deps.autorun =>
        lastUpdate = Session.set "lastUpdate", Date.now()
        
        if Meteor.userId() and 1==2
          App.call "getTwitterFriends",
            (err, data) =>
              if err and err.reason
                console.log err
              else
                Session.set "twitterFriends", data
  
  # adds gameId as first parameter after method in Meteor.call()
  @call: () =>
    args = _.toArray arguments
    method = args.shift()
    args.unshift Session.get "gameId"
    args.unshift method
    Meteor.call.apply Meteor.call, args
  
  @loadGame: (id) =>
    Session.set "gameLoading", true
    # access parameters in order a function args too
    handle = Meteor.subscribe "game", id, (err) =>
      #console.log "found..?"
      #Session.set id, true
      game = Game.findOne id
      if game
        #console.log "Showing game."
        Session.set "gameId", id
        Session.set "showGame", true
        Session.set "createError", null
      else
        #console.log "Okay, no game."
        Session.set "gameId", null
        Session.set "showGame", false
        Session.set "createError", "Game not found"
      Session.set "gameLoading", false
    game = Game.findOne id
    if game
      Session.set "gameId", id
      Session.set "showGame", true
      Session.set "gameLoading", false
  

app = @app = new @App()

Template.page.showGame = -> Session.get "showGame"