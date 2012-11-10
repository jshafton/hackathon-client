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
    "keypress #name":   "handleKeypress"

  handleKeypress: (event) ->
    # Submit form on enter key (char 13)
    return unless event.which == 13
    event.preventDefault()

    # Hack to explicitly update the model, since the enter key won't trigger
    # a change event.
    @model.set "name", @$("#name").val()

    @$("#nameForm").submit()
    return false

  save: (event) =>
    event.preventDefault()
    return unless @model.isValid()
    return unless @model.isValid()
    @trigger 'save'
