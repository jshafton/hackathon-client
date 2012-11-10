App.Views ||= {}

class App.Views.MainView extends Backbone.View
  initialize: ->
    @pusher = new Pusher('6a4677394df2ac8f08d2')
    channel = @pusher.subscribe('shafjac-test')
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
    Pusher.channel_auth_endpoint = "/pusher/auth/#{encodeURIComponent(App.runtime.currentPlayer.get('name'))}"
    presenceChannel = @pusher.subscribe 'presence-game'
    presenceChannel.bind 'pusher:member_added', (member) =>
      console.log "member #{member.info.name} added"
    @$("#mainContent").html "there's a round comin up #{App.runtime.currentPlayer.get('name')}"
