Template.home.events
  "click .start": (e) ->
    e.preventDefault()
    Meteor.Router.to "/login"
  "click .start-party": (e) ->
    e.preventDefault()

    Meteor.call "createRoom", (err, roomId) ->
      throw err if err
      Session.set "roomId", roomId
      #Session.set "showRoom", true
      Meteor.Router.to "/room/#{roomId}"
  "click .join-room": (e) ->
    e.preventDefault()
    roomId = @.roomId
    Meteor.call "joinRoom", roomId, (err, data) ->
      Meteor.Router.to "/room/#{roomId}"


Template.home.openRooms = ->
  rooms = Room.find({inProgress: false}, {sort: {createdAt: -1}}).fetch()
  ownerIds = _.map rooms, (room) -> room.owner
  roomsByOwner = {}
  _.each rooms, (room) -> roomsByOwner[room.owner] = room._id unless roomsByOwner[room.owner]?
  
  list = Meteor.users.find({_id: {"$in": ownerIds}}).fetch()
  _.map list, (user) ->
    displayName = "Anonymous"
    displayName = user.profile.name if user.profile?.name?
    displayName = user.emails[0].address if user.emails?.length > 0 and user.emails[0].address?
    if user._id == Meteor.userId()
      displayName += " (me)"
    {_id: user._id, displayName: displayName, roomId: roomsByOwner[user._id]}