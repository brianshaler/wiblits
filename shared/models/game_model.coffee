@Games = new Meteor.Collection "games"

@Games.allow
  insert: () -> false
  update: () -> false
  remove: () -> false
