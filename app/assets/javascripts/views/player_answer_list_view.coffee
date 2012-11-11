App.Views ||= {}

class App.Views.PlayerAnswerListView extends Backbone.View
  tagName: 'ul'

  render: ->
    @$el.empty()
    for model in @collection.models
      @$el.append HandlebarsTemplates['player_answer_item'](model.toJSON())
    @collection.on 'change', @render
    this
