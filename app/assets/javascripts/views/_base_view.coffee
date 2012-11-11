App.Views ||= {}

class App.Views.BaseView extends Backbone.View
  constructor: (options) ->
    @eventBindings = []
    @pusherBindings = []
    super(options)

  bindTo: (eventObject, event, callback) =>
    eventObject.on event, callback, this
    @eventBindings.push
      eventObject:  eventObject,
      event:        event,
      callback:     callback

  bindToPusherEvent: (channel, event, callback) =>
    channel.bind event, callback
    @pusherBindings.push
      channel: channel
      event: event
      callback: callback

  unbindFrom: (eventObject, event) =>
    eventObject.off event
    @eventBindings = _.reject(@eventBindings, (binding) =>
      binding.eventObject == eventObject && (typeof event == 'undefined' or event == binding.event)
    )

  unbindFromPusherEvent: (channel, event, callback) =>
    binding.channel.unbind binding.event, binding.callback for binding in @pusherBindings when binding.channel == channel and binding.event == event
    @pusherBindings = _.reject(@pusherBindings, (binding) =>
      binding.channel == channel and binding.event == event
    )

  unbindFromAll: =>
    binding.eventObject.unbind(binding.event, binding.callback) for binding in @eventBindings
    binding.channel.unbind binding.event, binding.callback for binding in @pusherBindings
    @eventBindings = []
    @pusherBindings = []

  dispose: =>
    @unbindFromAll()
    @unbind()
    Backbone.Validation.unbind this if Backbone.Validation
