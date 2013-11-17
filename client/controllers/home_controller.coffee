Template.home.events
  "click .start": (e) ->
    e.preventDefault()
    Meteor.Router.to "/login"