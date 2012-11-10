App.Views ||= {}

class App.Views.MainView extends Backbone.View
  PLAYER_NAME_COOKIE     = "player_name"
  API_KEY                = '6a4677394df2ac8f08d2'
  PUBLIC_CHANNEL         = 'public-channel'
  PRIVATE_SERVER_CHANNEL = 'private-server'
  ROUND_START_EVENT      = 'gamestartround'

  initialize: ->
    playerNameCookie = $.cookie(PLAYER_NAME_COOKIE)
    App.runtime.currentPlayer = new App.Models.Player(name: playerNameCookie) if playerNameCookie
    super

  render: =>
    @$el.html HandlebarsTemplates['main']
    @$("#header").html HandlebarsTemplates['header']

    # todo - flex this based on whether the user is logged in
    unless App.runtime.currentPlayer?
      playerModel = App.runtime.currentPlayer = new App.Models.Player()
      initialLoadView = new App.Views.InitialLoadView(model: playerModel)
      initialLoadView.on 'save', @playerReady
      @$("#mainContent").html initialLoadView.render().el
    else
      @waitingArea()
    this

  waitingArea: =>
    playerName = App.runtime.currentPlayer.get('name')
    @$("#playerName").text playerName
    $.cookie PLAYER_NAME_COOKIE, playerName, { expires: 14 }
    @subscribeToPusherEvents()
    playerView = new App.Views.PlayerBoardView()
    @$("#mainContent").html playerView.render().el

  subscribeToPusherEvents: =>
    playerName = App.runtime.currentPlayer.get('name')

    # Set up authentication using our bougs authenticator
    Pusher.channel_auth_endpoint = "/pusher/auth_jsonp/#{encodeURIComponent(playerName)}"
    Pusher.channel_auth_transport = 'jsonp'

    @pusher = new Pusher(API_KEY)

    # Public channel, for listening to global events
    @publicChannel = @pusher.subscribe(PUBLIC_CHANNEL)
    @publicChannel.bind ROUND_START_EVENT, @roundStarted

    # Private communication w/ the server since they don't support presence channels
    @serverChannel = @pusher.subscribe(PRIVATE_SERVER_CHANNEL)

    # Presence channel for monitoring member changes
    presenceChannel = @pusher.subscribe 'presence-game'