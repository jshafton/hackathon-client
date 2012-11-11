App.Models ||= {}

class App.Models.RoundStarted extends Backbone.Model
  getPlayersCollection: =>
    players = (player for player in @get('players') when player.type.toLowerCase() == 'player')
    new App.Models.Players(players)

  getJudgesCollection: =>
    judges = (player for player in @get('players') when player.type.toLowerCase() == 'judge')
    new App.Models.Players(judges)
