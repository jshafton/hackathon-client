App.Views ||= {}

class App.Views.SubmitGuessView extends App.Views.BaseView
  initialize: ->
    Backbone.Validation.bind this, forceUpdate: true
    super

  render: ->
    @$el.html HandlebarsTemplates['submit_guess_form']
    @modelBinder = new Backbone.ModelBinder()
    @modelBinder.bind @model, @el
    this

  events:
    "submit #guessForm": "save"
    "keypress #guess":   "handleKeypress"

  handleKeypress: (event) ->
    # Submit form on enter key (char 13)
    return unless event.which == 13
    event.preventDefault()

    # Hack to explicitly update the model, since the enter key won't trigger
    # a change event.
    @model.set "guess", @$("#guess").val()

    @$("#guessForm").submit()
    return false

  save: (event) =>
    event.preventDefault()
    return unless @model.isValid(true)
    @trigger 'save', @model
