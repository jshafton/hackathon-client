App.Views ||= {}

class App.Views.JudgeBoardView extends Backbone.View
  render: ->
    @$el.html HandlebarsTemplates['judge_board'](@model.toJSON())
    @$('id#playerAnswers').html new App.Views.PlayerAnswerListView()