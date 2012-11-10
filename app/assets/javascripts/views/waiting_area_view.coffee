App.Views ||= {}

class App.Views.WaitingAreaView extends Backbone.View
  render: ->
    @$el.html HandlebarsTemplates['waiting_area']
    this