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
    console.log email, password
    
    # Trim and validate your fields here.... 
    
    # If validation passes, supply the appropriate fields to the
    Meteor.loginWithPassword email, password, (err) ->
      if err
        console.log err
        # The user might not have been found, or their passwword
        # could be incorrect. Inform the user that their
        # login attempt has failed. 
      else
        console.log 'success'
    
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
    console.log email, password
    
    # Trim and validate the input
    Accounts.createUser
      email: email
      password: password
    , (err) ->
      if err
        console.log err.get_stack()
        # Inform the user that account creation failed
      else
        console.log 'success'

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