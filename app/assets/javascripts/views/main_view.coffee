App.Views ||= {}

class App.Views.MainView extends Backbone.View
  render: ->
    @$el.html HandlebarsTemplates['main']
    this
