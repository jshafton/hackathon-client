App.Views ||= {}

class App.Views.InitialLoadView extends App.Views.BaseView
  initialize: ->
    Backbone.Validation.bind this, forceUpdate: true
    super

  render: ->
    @$el.html HandlebarsTemplates['initial_load']
    @modelBinder = new Backbone.ModelBinder()
    @modelBinder.bind @model, @el
    this

  events:
    "submit #nameForm": "save"

  save: (event) =>
    event.preventDefault()
    return unless @model.isValid(true)
    @trigger 'save'
