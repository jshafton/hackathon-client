App.Models ||= {}

class App.Models.Player extends Backbone.Model
  defaults:
    "status": "Enjoying the view"

  validation:
    name:
      required: true
      msg: "Enter your name (less than 20 chars)"
      maxLength: 20
    email:
      required: true
      msg: "Enter your email (less than 50 chars)"
      maxLength: 50

class App.Models.Players extends Backbone.Collection
  model:
    App.Models.Player
