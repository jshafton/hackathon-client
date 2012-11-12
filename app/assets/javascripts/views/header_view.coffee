App.Views ||= {}

class App.Views.HeaderView extends App.Views.BaseView
  initialize: =>
    @bindTo @model, 'change', @updatePlayerName

  render: =>
    @$el.html HandlebarsTemplates['header'](@model.toJSON())
    this

  updatePlayerName: =>
    @$("#playerName").text @model.get('name')
