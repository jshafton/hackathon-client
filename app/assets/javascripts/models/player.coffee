App.Models ||= {}

class App.Models.Player extends Backbone.Model
  validation:
    name:
      required: true
      msg: "Enter your name"
    email:
      required: true
      msg: "Enter your email"

class App.Models.Players extends Backbone.Collection
  model:
    App.Models.Player
