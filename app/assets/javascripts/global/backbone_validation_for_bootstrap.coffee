# Backbone.validation configuration
if Backbone.Validation

  _.extend(Backbone.Model.prototype, Backbone.Validation.mixin)

  showTooltip = ->
    $(@).tooltip "show"

  hideTooltip = ->
    $(@).tooltip "hide"

  # Backbone.Modelbinding uses 'id' as the selector for everything
  # except radio buttons. This may cause us issues when we get to it.
  Backbone.Validation.configure
    selector: 'id'

  Backbone.Validation.removeTooltip = (view, attr, selector) =>
    inputElement = view.$("[#{selector} ~= '#{attr}']")

    # Only go through the ropes here if we know we marked it invalid previously.
    # If we don't do this, the call to inputElement.tooltip('hide') will create a
    # new tooltip with the defaults.
    return unless inputElement.attr("data-invalid")

    # Remove all tooltip attributes (it's important to get them all)
    inputElement
      .removeAttr("title")
      .removeAttr("data-original-title")
      .removeAttr("tooltip")
      .removeAttr("data-invalid")

    # Undo the red error class
    inputElement.closest("control-group")
      .removeClass("error")

    # Remove the event handlers so we don't have memory leak or ghosted tooltips
    inputElement.off "focus", showTooltip
    inputElement.off "blur", hideTooltip

    # Hide the tooltip so it doesn't linger if the content changes
    inputElement.tooltip('hide')

  # Set the control group to the error class, which marks it red
  # Set up a tooltip on the error element with the error text
  _.extend Backbone.Validation.callbacks,
    invalid: (view, attr, error, selector) ->
      inputElement = view.$("[#{selector} ~= '#{attr}']")

      Backbone.Validation.removeTooltip(view, attr, selector) if inputElement.attr("data-invalid")

      # Set the entire control group to the red error class
      inputElement.closest(".control-group")
        .addClass("error")

      # Set a tooltip over the invalid element with the error message
      inputElement
        .attr("title", error)
        .attr("data-original-title", error)
        .attr("rel", "tooltip")
        .attr("data-invalid", "true") # <-- this is a custom attribute to track our work

      # Figure out where to place the tooltip
      closestForm = inputElement.closest('form')
      placement =
        if closestForm.hasClass('form-horizontal') or closestForm.hasClass('form-inline') then 'bottom' else 'right'

      inputElement.tooltip(
        animation: false
        trigger: 'manual'
        placement: placement
      )

      # Manually hook up to events so we can unbind once valid
      inputElement.on "focus", showTooltip
      inputElement.on "blur", hideTooltip

      # Show the message right now if this element is active
      inputElement.tooltip("show") if $(document.activeElement).is(inputElement)

    valid: (view, attr, selector) ->
      Backbone.Validation.removeTooltip(view, attr, selector)
