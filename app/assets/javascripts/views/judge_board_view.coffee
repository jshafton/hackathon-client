App.Views ||= {}

class App.Views.JudgeBoardView extends App.Views.BaseView
  render: ->
    @$el.html HandlebarsTemplates['judge_board'](@model.toJSON())

    playerAnswers = new App.Models.PlayerAnswers()
    @answerListView.dispose() if @answerListView
    @answerListView = new App.Views.PlayerAnswerListView(collection: playerAnswers)
    @$("div#answers").html @answerListView.render().el

    this

  dispose: =>
    @answerListView.dispose() if @answerListView
    super