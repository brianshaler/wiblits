Template.signup.events "click #login_twitter": (e, tmpl) ->
  e.preventDefault()

  Meteor.loginWithTwitter {}, (err) ->
    if err
      # error handling
      # Basically they cancled out of it, no real error to handle
    else
      alert 'logged in...with twitter...'
      # show an alert
      # alert('logged in');

Template.signup.events "submit #login-form": (e, t) ->
  e.preventDefault()
  
  # retrieve the input field values
  email = t.find("#login-email").value
  password = t.find("#login-password").value
  
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


Template.register.events "submit #register-form": (e, t) ->
  e.preventDefault()

  # retrieve the input field values
  email = t.find("#account-email").value
  password = t.find("#account-password").value
  
  # Trim and validate the input
  Accounts.createUser
    email: email
    password: password
  , (err) ->
    if err
      console.log err
      # Inform the user that account creation failed
    else
      console.log 'success'

  # Success. Account has been created and the user
  # has logged in successfully. 
  false

  Template.logout.events
    "click button": (e) ->
      #console.log e
      Meteor.logout()