App.Routers ||= {}

class App.Routers.MainRouter extends Backbone.Router
  @PLAYER_DATA_COOKIE = "player_data"
  HEADER_DIV          = "#header"
  MAIN_CONTENT_DIV    = "#mainContent"

  initialize: ->
    @bind 'beforeroute', @readPlayerCookie
    @bind 'beforeroute', @showHeaderView
    super

  # Override the base route mechanism so we can inject a "before" trigger
  route: (route, name, callback) =>
    super route, name, =>
      @trigger.apply this, ['beforeroute'].concat(name, _.toArray(arguments))
      @trigger.apply this, ['beforeroute:' + name].concat(_.toArray(arguments))
      callback = @[name] unless callback
      callback && callback.apply this, arguments

  routes:
    "":   "home"
    "!":  "home"
    "!/": "home"

    "!/play": "play"

  readPlayerCookie: ->
    playerDataCookie = $.cookie(MainRouter.PLAYER_DATA_COOKIE)
    App.runtime.currentPlayer = new App.Models.Player(JSON.parse(playerDataCookie)) if playerDataCookie

  showHeaderView: (routeName, args) =>
    if routeName == 'home'
      $(HEADER_DIV).hide()
      if @currentHeaderView
        @currentHeaderView.dispose()
        @currentHeaderView = null

    return unless App.runtime.currentPlayer
    return $(HEADER_DIV).show() if @currentHeaderView

    @currentHeaderView = new App.Views.HeaderView(model: App.runtime.currentPlayer)
    $(HEADER_DIV).html @currentHeaderView.render().el

  home: =>
    App.runtime.currentPlayer = new App.Models.Player() unless App.runtime.currentPlayer
    @_showView(new App.Views.HomeView(model: App.runtime.currentPlayer))

  play: =>
    @_showView(new App.Views.MainView())

  _showView: (view) =>
    @currentContentView.dispose() if @mainView?.dispose
    @currentContentView = view
    $(MAIN_CONTENT_DIV).html view.render().el
