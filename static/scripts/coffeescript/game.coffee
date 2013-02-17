console.log "WTF"

define [
    'jquery'
    'kinetic'
    'levels'
    'menus'
    'play'
], ($, K, LevelsPage, FrontPage, PlayLevel) ->

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

      # event listeners:

      $(document).bind "request-levels-menu", =>
        @showLevels({})

      $(document).bind "request-level-start", (e, level) =>
        console.log 'clicked and level is', level
        @startLevel({})


    

    startGame: ()->
      # first we draw the menus
      console.log 'starting game!'

      frontpage = new FrontPage(@, @stage, @layer)


    showLevels: ({page}) ->
      console.log 'showing levels'
      page ?= 0

      @stage.removeChildren()
      @menuLayer = new K.Layer()
      @stage.add(@menuLayer)
      levelsPage = new LevelsPage(@, @menuLayer)

    startLevel: (level)->
      # first we draw the menus
      console.log 'starting level! ' + level

      level = new PlayLevel(@, @stage, @layer)


  return Game