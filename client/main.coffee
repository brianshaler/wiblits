Meteor.subscribe "games"

@initRoutes()

class @App
  constructor: ->
    #@game = new GameController()
    
    Meteor.startup =>
      #root.viewport = new Viewporter "outer-container", fullHeightPortrait: false
      
      # hack
      Deps.autorun =>
        lastUpdate = Session.set "lastUpdate", Date.now()
        
        if Meteor.userId() and 1==2 # not ready yet
          App.call "getFriends",
            (err, data) =>
              if err and err.reason
                console.log err
              else
                Session.set "friends", data
  
  # adds gameId as first parameter after method in Meteor.call()
  @call: () =>
    args = _.toArray arguments
    method = args.shift()
    args.unshift Session.get "gameId"
    args.unshift method
    Meteor.call.apply Meteor.call, args

app = @app = new @App()
