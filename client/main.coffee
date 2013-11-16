Meteor.subscribe "rooms"
Meteor.subscribe "allUsers"

@initRoutes()


class @App
  constructor: ->
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
  
  # adds roomId as first parameter after method in Meteor.call()
  @call: () =>
    args = _.toArray arguments
    method = args.shift()
    args.unshift Session.get "roomId"
    args.unshift method
    Meteor.call.apply Meteor.call, args
  
  @loadRoom: (id) =>
    Session.set "roomLoading", true
    # access parameters in order a function args too
    handle = Meteor.subscribe "room", id, (err) =>
      #console.log "found..?"
      #Session.set id, true
      room = Room.findOne id
      if room
        #console.log "Showing room."
        Session.set "roomId", id
        Session.set "showRoom", true
        Session.set "createError", null
      else
        #console.log "Okay, no room."
        Session.set "roomId", null
        Session.set "showRoom", false
        Session.set "createError", "Room not found"
      Session.set "roomLoading", false
    room = Room.findOne id
    if room
      Session.set "roomId", id
      Session.set "showRoom", true
      Session.set "roomLoading", false

app = @app = new @App()

Template.page.showRoom = -> Session.get "showRoom"


Deps.autorun =>
  $('body').removeClass()
  $("body").addClass("home")  if Session.get "showRoom"
