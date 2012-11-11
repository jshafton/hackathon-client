App.Views ||= {}

class App.Views.PlayerListView extends App.Views.BaseView
  tagName: 'ul'

  initialize: =>
    @bindToPusherEvent App.runtime.channels.public, 'game-guess-submitted', @guessSubmitted
    @bindToPusherEvent App.runtime.channels.presence, 'pusher:member_removed', @playerDropped

  render: =>
    @$el.html ''
    @unbindFrom @collection, 'change'
    for model in @collection.models
      @$el.append HandlebarsTemplates['player_board_item'](model.toJSON())
    @bindTo @collection, 'change', @render
    this

  guessSubmitted: (eventData) =>
    console.log "guess submitted - #{JSON.stringify(eventData)}"
    matchingModel.set(status: 'Guess submitted') for matchingModel in @collection.models when matchingModel.get('name') == eventData.player

  playerDropped: (eventData) =>
    @collection.remove(model) for model in @collection.models when model.get('name') == eventData.player
