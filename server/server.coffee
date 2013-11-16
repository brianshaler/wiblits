
Meteor.publish "games", () ->
  q = [{public: true}]
  if this.userId
    check this.userId, String
    q.push players: this.userId
    q.push owner: this.userId
  Games.find
    $or: q
    {
      sort:
        createdDate: -1
      limit: 10
    }
