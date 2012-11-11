App.Views ||= {}

class App.Views.MainView extends Backbone.View
  PLAYER_DATA_COOKIE     = "player_data"
  API_KEY                = '6a4677394df2ac8f08d2'
  PUBLIC_CHANNEL         = 'public'
  PRIVATE_SERVER_CHANNEL = 'private-server'
  ROUND_START_EVENT      = 'game-round-started'

  initialize: ->
    playerDataCookie = $.cookie(PLAYER_DATA_COOKIE)
    App.runtime.currentPlayer = new App.Models.Player(JSON.parse(playerDataCookie)) if playerDataCookie
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
      @playerReady()

    this

  playerReady: =>
    @$("#playerName").text App.runtime.currentPlayer.get('name')
    $.cookie PLAYER_DATA_COOKIE, JSON.stringify(App.runtime.currentPlayer.toJSON()), { expires: 14 }
    @showWaitingAreaView()
    @subscribeToPusherEvents()

  showWaitingAreaView: =>
    @$("#mainContent").html HandlebarsTemplates['waiting_area']

  subscribeToPusherEvents: =>
    playerName = App.runtime.currentPlayer.get('name')
    playerEmail = App.runtime.currentPlayer.get('email')

    # Set up authentication using our bougs authenticator
    Pusher.channel_auth_endpoint = "/pusher/auth_jsonp/#{encodeURIComponent(playerName)}/#{encodeURIComponent(playerEmail)}"
    Pusher.channel_auth_transport = 'jsonp'

    @pusher = new Pusher(API_KEY)

    # Public channel, for listening to global events
    @publicChannel = @pusher.subscribe(PUBLIC_CHANNEL)
    @publicChannel.bind ROUND_START_EVENT, @roundStarted

    # Private communication w/ the server since they don't support presence channels
    @serverChannel = @pusher.subscribe(PRIVATE_SERVER_CHANNEL)

    # Presence channel for monitoring member changes
    presenceChannel = @pusher.subscribe 'presence-game'
    presenceChannel.bind 'pusher:subscription_succeeded', @presenceChannelSubscribed
    presenceChannel.bind 'pusher:member_added', @playerAdded
    presenceChannel.bind 'pusher:member_removed', @playerDropped

  presenceChannelSubscribed: (members) =>
    # Private channel for player-only communications
    @playerChannel = @pusher.subscribe(members.me.info.private_channel) if members?.me?.info?.private_channel

  playerAdded: (player) =>
    console.log "player #{player.info.name} added"
    @serverChannel.trigger 'client-player-added', player

  playerDropped: (player) =>
    console.log "player #{player.info.name} dropped"
    @serverChannel.trigger 'client-player-dropped', player

  roundStarted: (eventData) =>
    console.log "round started - #{JSON.stringify(eventData)}"
    roundStartedModel = new App.Models.RoundStarted(eventData)
    playerView = new App.Views.PlayerBoardView(model: roundStartedModel)
    @$("#mainContent").html playerView.render().el
