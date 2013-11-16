@Room = new Meteor.Collection "room"

@Room.allow
  insert: () -> false
  update: () -> false
  remove: () -> false

@RoomSchema =
  owner: ""
  public: false
  started: false
  invites: []
  players: []
  createdAt: new Date()
