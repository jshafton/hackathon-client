App.Views ||= {}

class App.Views.PlayerListView extends App.Views.BaseView
  tagName: 'ul'

  initialize: =>
    App.runtime.channels.public.bind 'game-guess-submitted', @guessSubmitted
    App.runtime.channels.presence.bind 'pusher:member_removed', @playerDropped

  render: =>
    @$el.html ''
    for model in @collection.models
      @$el.append HandlebarsTemplates['player_board_item'](model.toJSON())
    @bindTo @collection, 'change', @render
    this

  guessSubmitted: (eventData) =>
    console.log "guess submitted - #{JSON.stringify(eventData)}"
    matchingModel.set(status: 'Guess submitted') for matchingModel in @collection.models when matchingModel.get('name') == eventData.player

  playerDropped: (eventData) =>
    @collection.remove(model) for model in @collection.models when model.get('name') == eventData.player

  dispose: =>
    App.runtime.channels.public.unbind 'game-guess-submitted'
    App.runtime.channels.presence.unbind 'pusher:member_removed'
    super
