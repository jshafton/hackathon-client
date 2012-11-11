App.Views ||= {}

class App.Views.PlayerAnswerListView extends App.Views.BaseView
  tagName: 'ul'

  render: =>
    @$el.html ''
    for model in @collection.models
      @$el.append HandlebarsTemplates['player_answer_item'](model.toJSON())
    @collection.on 'change', @render
    this
