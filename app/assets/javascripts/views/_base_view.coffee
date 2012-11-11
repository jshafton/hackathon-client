App.Views ||= {}

class App.Views.BaseView extends Backbone.View
  constructor: (options) ->
    @eventBindings = []
    super(options)

  bindTo: (eventObject, event, callback) =>
    eventObject.on event, callback, this
    @eventBindings.push
      eventObject:  eventObject,
      event:        event,
      callback:     callback

  unbindFrom: (eventObject, event) =>
    eventObject.off event
    @eventBindings = _.reject(@eventBindings, (binding) =>
      binding.eventObject == eventObject && (typeof event == 'undefined' or event == binding.event)
    )

  unbindFromAll: ->
    binding.eventObject.unbind(binding.event, binding.callback) for binding in @eventBindings
    @eventBindings = []

  dispose: ->
    @unbindFromAll()
    @unbind()
    Backbone.Validation.unbind this if Backbone.Validation
