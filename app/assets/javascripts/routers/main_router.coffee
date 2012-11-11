App.Routers ||= {}

class App.Routers.MainRouter extends Backbone.Router
  MAIN_CONTENT_DIV = "#content"

  routes:
    "":   "home"
    "!":  "home"
    "!/": "home"

  home: ->
    @mainView.dispose() if @mainView
    @mainView = new App.Views.MainView()
    $(MAIN_CONTENT_DIV).html @mainView.render().el
