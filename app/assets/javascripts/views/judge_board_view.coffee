App.Views ||= {}

class App.Views.JudgeBoardView extends App.Views.BaseView
  render: ->
    @$el.html HandlebarsTemplates['judge_board'](@model.toJSON())
    playerAnswers = new App.Models.PlayerAnswers()
    playerAnswers.add(new App.Models.PlayerAnswer())
    @answerListView.dispose() if @answerListView
    @answerListView = new App.Views.PlayerAnswerListView(collection: playerAnswers)
    @$("#playerAnswers").html @answerListView.render().el

  dispose: =>
    @answerListView.dispose() if @answerListView
    super
