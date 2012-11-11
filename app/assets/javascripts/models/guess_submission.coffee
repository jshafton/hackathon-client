App.Models ||= {}

class App.Models.GuessSubmission extends Backbone.Model
  validation:
    guess:
      required: true
      msg: "Enter your guess"
