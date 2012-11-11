App.Views ||= {}

class App.Views.MainView extends App.Views.BaseView
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
      @$("#header").hide()
      playerModel = App.runtime.currentPlayer = new App.Models.Player()
      @initialLoadView = new App.Views.InitialLoadView(model: playerModel)
      @bindTo initialLoadView, 'save', @playerReady
      @$("#mainContent").html initialLoadView.render().el
    else
      @playerReady()

    this

  events:
    "click .brand": "clickBrand"

  clickBrand: (event) =>
    event.preventDefault()

  playerReady: =>
    @currentPlayer = App.runtime.currentPlayer.get('name')
    @$("#playerName").text @currentPlayer
    $.cookie PLAYER_DATA_COOKIE, JSON.stringify(App.runtime.currentPlayer.toJSON()), { expires: 14 }
    @$("#header").show()
    @showWaitingAreaView()
    @subscribeToPusherEvents()

  showWaitingAreaView: =>
    @$("#mainContent").html HandlebarsTemplates['waiting_area']

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
    App.runtime.channels.public.bind ROUND_START_EVENT, @roundStarted

    # Private communication w/ the server since they don't support presence channels
    App.runtime.channels.server = App.runtime.pusher.subscribe(PRIVATE_SERVER_CHANNEL)

    # Presence channel for monitoring member changes
    App.runtime.channels.presence = App.runtime.pusher.subscribe 'presence-game'
    App.runtime.channels.presence.bind 'pusher:subscription_succeeded', @presenceChannelSubscribed
    App.runtime.channels.presence.bind 'pusher:member_added', @playerAdded
    App.runtime.channels.presence.bind 'pusher:member_removed', @playerDropped

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
      @judgeView.dispose() if @playerView
      @judgeView = new App.Views.JudgeBoardView(model: roundStartedModel)
      @$("#mainContent").html @judgeView.render().el
    else
      @playerView.dispose() if @playerView
      @playerView = new App.Views.PlayerBoardView(model: roundStartedModel)
      @$("#mainContent").html @playerView.render().el

  dispose: =>
    App.runtime.pusher.unsubscribe(PUBLIC_CHANNEL)
    App.runtime.pusher.unsubscribe(PRIVATE_SERVER_CHANNEL)
    App.runtime.pusher.unsubscribe('presence-game')
    App.runtime.Pusher.disconnect() if App.runtime.Pusher
    @initialLoadView.dispose() if @initialLoadView
    @playerView.dispose() if @playerView
    super
