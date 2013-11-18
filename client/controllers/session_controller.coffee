Template.signup.events "click #login_twitter": (e, tmpl) ->
  e.preventDefault()

  Meteor.loginWithTwitter {}, (err) ->
    unless err
      roomId = Session.get "roomId"
      if roomId?
        Meteor.call "joinRoom", roomId, (err, data) ->
          Meteor.Router.to "/room/#{roomId}"
      else
        Meteor.Router.to "/"

Template.signup.events
  "submit #login_form": (e, t) ->
    e.preventDefault()
    console.lo
    
    # retrieve the input field values
    email = $("#email").val()
    password = $("#password").val()
    # Trim and validate your fields here.... 
    
    # If validation passes, supply the appropriate fields to the
    Meteor.loginWithPassword email, password, (err) ->
      # Need to handle error, but fukit...
      unless err
        roomId = Session.get "roomId"
        if roomId?
          Meteor.call "joinRoom", roomId, (err, data) ->
            Meteor.Router.to "/room/#{roomId}"
        else
          Meteor.Router.to "/"
    
    # The user has been logged in.
    false
  "click #go_to_register": (e) ->
    el = $($(e.target).attr('data-target'))
    el.attr('id', 'register_form')
    $('.go-to-register').addClass('hide')
    $('.go-to-login').removeClass('hide')

  "submit #register_form": (e, t) ->
    e.preventDefault()

    # retrieve the input field values
    email = $("#email").val()
    password = $("#password").val()
    
    # Trim and validate the input
    Accounts.createUser
      email: email
      password: password
    , (err) ->
      # Need to handle error, but fukit...
      unless err
        roomId = Session.get "roomId"
        if roomId?
          Meteor.call "joinRoom", roomId, (err, data) ->
            Meteor.Router.to "/room/#{roomId}"
        else
          Meteor.Router.to "/"

    # Success. Account has been created and the user
    # has logged in successfully. 
    false
  
  "click #go_to_login": (e) ->
    el = $($(e.target).attr('data-target'))
    el.attr('id', 'login_form')
    $('.go-to-register').removeClass('hide')
    $('.go-to-login').addClass('hide')

  "click #register_twitter": (e, tmpl) ->
    e.preventDefault()

    Meteor.loginWithTwitter {}, (err) ->
      unless err
        roomId = Session.get "roomId"
        if roomId?
          Meteor.call "joinRoom", roomId, (err, data) ->
            Meteor.Router.to "/room/#{roomId}"
        else
          Meteor.Router.to "/"

Template.logout.events
  "click button": (e) ->
    e.preventDefault()
    Meteor.logout()