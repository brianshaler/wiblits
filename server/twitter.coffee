opt =
  consumer_key: "uM82UIJfUYqRTpsYBD8HBw"
  consumer_secret: "zBVnLQMt7fKFlO7AoC8Nk32tD8LMsJwrU0jn0HJ9Q"
  access_token: ""
  access_token_secret: ""

@GetTwitter = (token, secret) ->
  opt.access_token = token
  opt.access_token_secret = secret
  return new TwitMaker opt

#@Twit = new TwitMaker opt
