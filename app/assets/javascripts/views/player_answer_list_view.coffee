App.Views ||= {}

class App.Views.PlayerAnswerListView extends App.Views.BaseView
  tagName: 'ul'

  initialize: ->
    @bindToPusherEvent App.runtime.channels.public, 'game-guess-submitted', @guessSubmitted
    super

  render: =>
    @$el.html ''
    for model in @collection.models
      @$el.append HandlebarsTemplates['player_answer_item'](model.toJSON())
    @collection.on 'add', @render
    this

  guessSubmitted: (eventData) =>
    console.log "guess submitted - #{JSON.stringify(eventData)}"
    #TODO: Server needs to add answer to event data
    @collection.add(new App.Models.PlayerAnswer(answer: eventData.answer))