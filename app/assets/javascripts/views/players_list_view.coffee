App.Views ||= {}

class App.Views.PlayerListView extends Backbone.View
  tagName: 'ul'

  render: ->
    @$el.empty()
    for model in @collection.models
      @$el.append HandlebarsTemplates['player_board_item'](model.toJSON())
    @collection.on 'change', @render
    this
