App.Views ||= {}

class App.Views.MainView extends Backbone.View
  initialize: ->
    @pusher = new Pusher('6a4677394df2ac8f08d2')
    channel = @pusher.subscribe('shafjac-test')
    channel.bind 'test-event', @onTestEvent
    super

  render: ->
    @$el.html HandlebarsTemplates['main']
    this

  onTestEvent: (data) =>
    @$('#pusher-text').html data.message
