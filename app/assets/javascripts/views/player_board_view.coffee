App.Views ||= {}

class App.Views.PlayerBoardView extends Backbone.View
  render: ->
    @$el.html HandlebarsTemplates['player_board']
    this