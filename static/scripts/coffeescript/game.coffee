
define [
    'jquery'
    'kinetic'
], ($, K) ->

  class Game

    constructor: (@container) ->
      @width = $(window).width()
      @height = $(window).height()

      console.log @width, @height

      @stage = new K.Stage
        container: @container
        width: @width
        height: @height
      @layer = new K.Layer()

      # add the layer to the stage
      @stage.add(@layer)
      @layer.draw()


  game = new Game('container')

  return game