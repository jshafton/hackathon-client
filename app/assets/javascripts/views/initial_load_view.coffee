App.Views ||= {}

class App.Views.InitialLoadView extends Backbone.View
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
    return unless @model.isValid()
    @trigger 'save'
