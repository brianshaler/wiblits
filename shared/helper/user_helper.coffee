@UserHelper = 
  getUserName: () ->
    user = Meteor.user()
    displayName = "Anonymous"
    displayName = user.profile.name if user.profile?.name?
    displayName = user.emails[0].address if user.emails?.length > 0 and user.emails[0].address?
    return displayName