App.Views ||= {}

class App.Views.JudgeBoardView extends Backbone.View
  render: ->
    @$el.html HandlebarsTemplates['judge_board'](@model.toJSON())
    playerAnswers = new App.Models.PlayerAnswers()
    playerAnswers.add(new App.Models.PlayerAnswer())
    view = App.Views.PlayerAnswerListView(collection: playerAnswers.toJSON())
    @$("#playerAnswers").html view.render().el