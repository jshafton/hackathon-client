App.Views ||= {}

class App.Views.PlayerBoardView extends App.Views.BaseView
  render: ->
    @$el.html HandlebarsTemplates['player_board'](@model.toJSON())

    @playersCollection = @model.getPlayersCollection()
    @playersView.dispose() if @playersView
    @playersView = new App.Views.PlayerListView(collection: @playersCollection)
    @$("#playerList").html @playersView.render().el

    @judgesCollection = @model.getJudgesCollection()
    @judgesView.dispose() if @judgesView
    @judgesView = new App.Views.PlayerListView(collection: @judgesCollection)
    @$("#judgeList").html @judgesView.render().el

    # Attach the form for submitting a guess
    guessModel = new App.Models.GuessSubmission()
    @guessView.dispose() if @guessView
    @guessView = new App.Views.SubmitGuessView(model: guessModel)
    @bindTo @guessView, 'save', @guessEntered
    @$("#guessArea").html @guessView.render().el
    this

  guessEntered: (model) =>
    guess = model.get('guess')
    @guessView.$el.hide()
    App.runtime.channels.player.trigger 'client-guess-submitted',
      round_id:  @model.get('round_id'),
      player:    App.runtime.currentPlayer.get('name')
      guess:     guess

  dispose: =>
    @guessView.dispose() if @guessView
    @playersView.dispose() if @playersView
    @judgesView.dispose() if @judgesView
    super
