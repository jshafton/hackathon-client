App.Views ||= {}

class App.Views.MainView extends App.Views.BaseView
  API_KEY                = '6a4677394df2ac8f08d2'
  PUBLIC_CHANNEL         = 'public'
  PRIVATE_SERVER_CHANNEL = 'private-server'
  ROUND_START_EVENT      = 'game-round-started'

  initialize: =>
    Backbone.history.navigate("/", trigger: true) unless App.runtime.currentPlayer?
    @currentPlayer = App.runtime.currentPlayer.get('name')
    @subscribeToPusherEvents()
    super

  render: =>
    @$el.html HandlebarsTemplates['waiting_area']
    this

  subscribeToPusherEvents: =>
    playerName = App.runtime.currentPlayer.get('name')
    playerEmail = App.runtime.currentPlayer.get('email')

    # Set up authentication using our bougs authenticator
    Pusher.channel_auth_endpoint = "/pusher/auth_jsonp"
    Pusher.channel_auth_transport = 'jsonp'
    options =
      auth:
        params:
          player_email: playerEmail
          player_name: playerName
    #Pusher.log = (msg) =>
      #console.log "PUSHER - #{JSON.stringify(msg)}"

    App.runtime.pusher = new Pusher(API_KEY, options)
    App.runtime.channels ||= {}

    # Public channel, for listening to global events
    App.runtime.channels.public = App.runtime.pusher.subscribe(PUBLIC_CHANNEL)
    @bindToPusherEvent App.runtime.channels.public, ROUND_START_EVENT, @roundStarted

    # Private communication w/ the server since they don't support presence channels
    App.runtime.channels.server = App.runtime.pusher.subscribe(PRIVATE_SERVER_CHANNEL)

    # Presence channel for monitoring member changes
    App.runtime.channels.presence = App.runtime.pusher.subscribe 'presence-game'
    @bindToPusherEvent App.runtime.channels.presence, 'pusher:subscription_succeeded', @presenceChannelSubscribed
    @bindToPusherEvent App.runtime.channels.presence, 'pusher:member_added', @playerAdded
    @bindToPusherEvent App.runtime.channels.presence, 'pusher:member_removed', @playerDropped

  presenceChannelSubscribed: (members) =>
    # Private channel for player-only communications
    if members?.me?.info?.private_channel
      App.runtime.channels.player = App.runtime.pusher.subscribe(members.me.info.private_channel)

  playerAdded: (player) =>
    console.log "player #{player.info.name} added"
    App.runtime.channels.server.trigger 'client-player-added', player

  playerDropped: (player) =>
    console.log "player #{player.info.name} dropped"
    App.runtime.channels.server.trigger 'client-player-dropped', player

  roundStarted: (eventData) =>
    console.log "round started - #{JSON.stringify(eventData)}"
    roundStartedModel = new App.Models.RoundStarted(eventData)
    judge = roundStartedModel.getJudgesCollection().first()
    if judge.attributes["name"] == @currentPlayer
      @judgeView.dispose() if @judgeView
      @judgeView = new App.Views.JudgeBoardView(model: roundStartedModel)
      $("#mainContent").html @judgeView.render().el
    else
      @playerView.dispose() if @playerView
      @playerView = new App.Views.PlayerBoardView(model: roundStartedModel)
      $("#mainContent").html @playerView.render().el

  dispose: =>
    if App.runtime.Pusher
      App.runtime.pusher.unsubscribe(PUBLIC_CHANNEL)
      App.runtime.pusher.unsubscribe(PRIVATE_SERVER_CHANNEL)
      App.runtime.pusher.unsubscribe('presence-game')
      App.runtime.Pusher.disconnect()
    @initialLoadView.dispose() if @initialLoadView
    @playerView.dispose() if @playerView
    super
