@Room = new Meteor.Collection "room"

@Room.allow
  insert: () -> false
  update: () -> false
  remove: () -> false

@RoomSchema =
  owner: ""
  public: false
  started: false
  starting: false
  startAt: null
  inProgress: false
  game: false
  invites: []
  players: []
  inRoom: []
  createdAt: new Date()
