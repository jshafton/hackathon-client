App.Views ||= {}

class App.Views.PlayerBoardView extends Backbone.View
  render: ->
    @$el.html HandlebarsTemplates['player_board'](@model.toJSON())

    @playersCollection = @model.getPlayersCollection()
    @playersView = new App.Views.PlayerListView(collection: @playersCollection)
    @$("#playerList").html @playersView.render().el

    @judgesCollection = @model.getJudgesCollection()
    @judgesView = new App.Views.PlayerListView(collection: @judgesCollection)
    @$("#judgeList").html @judgesView.render().el

    # Attach the form for submitting a guess
    guessModel = new App.Models.GuessSubmission()
    @guessView = new App.Views.SubmitGuessView(model: guessModel)
    @guessView.on 'save', @guessEntered
    @$("#guessArea").html @guessView.render().el
    this

  guessEntered: (model) =>
    guess = model.get('guess')
    @guessView.remove()
    App.runtime.channels.player.trigger 'client-guess-submitted',
      round_id:  @model.get('round_id'),
      player:    App.runtime.currentPlayer.get('name')
      guess:     guess
