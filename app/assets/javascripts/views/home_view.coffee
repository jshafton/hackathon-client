App.Views ||= {}

class App.Views.HomeView extends App.Views.BaseView
  initialize: ->
    Backbone.Validation.bind this, forceUpdate: true
    super

  render: =>
    @$el.html HandlebarsTemplates['home']
    @modelBinder = new Backbone.ModelBinder()
    @modelBinder.bind @model, @el
    this

  events:
    "submit #nameForm": "save"

  save: (event) =>
    event.preventDefault()
    return unless @model.isValid(true)
    $.cookie App.Routers.MainRouter.PLAYER_DATA_COOKIE, JSON.stringify(@model.toJSON()), { expires: 14 }
    Backbone.history.navigate '!/play', trigger: true
