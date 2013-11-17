Template.signup.events "click #login_twitter": (e, tmpl) ->
  e.preventDefault()

  Meteor.loginWithTwitter {}, (err) ->
    unless err
      alert 'logged in...with twitter...'

Template.signup.events
  "submit #login_form": (e, t) ->
    e.preventDefault()
    
    # retrieve the input field values
    email = $("#login_email").val()
    password = $("#login_password").val()
    # Trim and validate your fields here.... 
    
    # If validation passes, supply the appropriate fields to the
    Meteor.loginWithPassword email, password, (err) ->
      # Need to handle error, but fukit...
      unless err
        roomId = Session.get "roomId"
        if roomId?
          Meteor.Router.to "/room/#{roomId}"
        else
          Meteor.Router.to "/"
    
    # The user has been logged in.
    false
  "click #go_to_register": (e) ->
    e.preventDefault()
    Meteor.Router.to "/register"


Template.register.events
  "submit #register_form": (e, t) ->
    e.preventDefault()

    # retrieve the input field values
    email = $("#account_email").val()
    password = $("#account_password").val()
    
    # Trim and validate the input
    Accounts.createUser
      email: email
      password: password
    , (err) ->
      # Need to handle error, but fukit...
      unless err
        roomId = Session.get "roomId"
        if roomId?
          Meteor.Router.to "/room/#{roomId}"
        else
          Meteor.Router.to "/"

    # Success. Account has been created and the user
    # has logged in successfully. 
    false
  
  "click #go_to_login": (e) ->
    e.preventDefault()
    Meteor.Router.to "/login"

  "click #register_twitter": (e, tmpl) ->
    e.preventDefault()

    Meteor.loginWithTwitter {}, (err) ->
      unless err
        alert 'logged in...with twitter...'

Template.logout.events
  "click button": (e) ->
    e.preventDefault()
    Meteor.logout()