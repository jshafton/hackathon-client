App.Views ||= {}

class App.Views.JudgeBoardView extends App.Views.BaseView
  initialize: ->
    #TODO: this below is supposed to be private
    @bindToPusherEvent App.runtime.channels.public, 'game-judging-ready', @readyToJudge

  render: ->
    @$el.html HandlebarsTemplates['judge_board'](@model.toJSON())
    playerAnswers = new App.Models.PlayerAnswers()
    @answerListView.dispose() if @answerListView
    @answerListView = new App.Views.PlayerAnswerListView(collection: playerAnswers)
    @$("div#answers").html @answerListView.render().el
    this

  events:
    "submit #judgeAnswers": "answerSelected"

  readyToJudge: (eventData) =>
    @$("input#btnPickAnswer").removeAttr('disabled');

  dispose: =>
    @answerListView.dispose() if @answerListView
    super

  answerSelected: (model) =>
    winningPlayer = $('input[name=answers]:checked', '#judgeAnswers').val()
    @$("input#btnPickAnswer").addAttr('disabled');
    App.runtime.channels.player.trigger 'client-judging-submitted',
      round_id: @model.get('round_id'),
      winning_player: winningPlayer