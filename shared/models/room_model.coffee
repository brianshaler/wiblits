@Room = new Meteor.Collection "room"

@Room.allow
  insert: () -> false
  update: () -> false
  remove: () -> false

@RoomSchema =
  owner: ""
  public: false
  started: false
  inProgress: false
  game: false
  invites: []
  players: []
  inRoom: []
  createdAt: new Date()
