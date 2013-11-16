# Wrapped in a method so it can be invoked on initial load after "app" is created
@initRoutes = ->
  # I think this filter prevents the page from initially showing you 
  # logged out while it figures out that you're logged in...
  Meteor.Router.filters
    "checkLoggedIn": (page) ->
      if Meteor.loggingIn()
        return "loading"
      else
        return page
  Meteor.Router.filter "checkLoggedIn"
  
  Meteor.Router.beforeRouting = () ->
    "stuff to do before routing.."
  
  Meteor.Router.add
    "/game/:id":
      as: "gamePage"
      to: (id) ->
        app.game.loadGame id
        "page"
    "/": ->
      Session.set "gameId", null
      Session.set "showGame", false
      "page"
    "*": "not_found"
