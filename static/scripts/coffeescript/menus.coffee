
define [
    'jquery'
    'kinetic'
    'tools'
], ($, K, tools) ->
  class FrontPage
    constructor: (@game, @stage, @baseLayer) ->

      console.log 'constructing the fucking frontpage'

      game = @game
      stage = @stage
      baseLayer = @baseLayer

      console.log "stage is!", stage

      w = stage.getWidth()
      h = stage.getHeight()

      console.log "attempting to draw logo"

      logo = tools.createImage
        stage: stage
        name: 'logo'
        src: 'static/images/logo.png'
        top: 0.2
        left: 0.5
        width: 1.0
        marginLeft: -0.5
        marginTop: -0.5
        callback: (image) =>
          baseLayer.add(image)
          baseLayer.draw()

      console.log "logo is", logo

      laoshi = tools.createImage
        stage: stage
        name: 'laoshi'
        src: 'static/images/laoshi.png'
        top: 0.95
        left: 0.5
        width: 0.5
        height: 0.5
        marginTop: -1.0
        marginLeft: 0.0
        callback: (image) =>
          baseLayer.add(image)
          baseLayer.draw()

      ground = new K.Rect
        x: 0
        y: h * 0.9
        width: w
        height: h * 0.1
        name: 'ground'
        fill: '#170801'
        stroke: 'none'
        strokeWidth: 0


      baseLayer.add(ground)


      # draw menu buttons:
      # ==================

      buttonLayer = new K.Layer
        'name': 'buttons'

      startGame = tools.createRect
        stage: stage
        top: 0.3
        left: 0.5
        width: 0.5
        marginLeft: -0.5
        marginTop: 0
        height: 60
        name: 'startGame'
        fill: '#f2f2ea'
        stroke: '#259bcb'
        strokeWidth: 5

      tools.addShadow(startGame)

      buttonText = new K.Text
        x: w * 0.5 - startGame.getWidth() / 2
        y: h * 0.3
        text: 'Story'
        fontSize: 40
        fontFamily: 'karatemedium'
        fill: 'black'
        align: 'center'
        width: startGame.getWidth()
        padding: 10

      startGameButton = new K.Group()
      startGameButton.add(startGame)
      startGameButton.add(buttonText)

      startGameButton.on 'mouseup touchend', ->
        $.event.trigger("request-levels-menu")

      startGameButton.on 'mouseover', ->
        startGame.setStroke('#3e6473')
        document.body.style.cursor = 'pointer';
        buttonLayer.draw()

      startGameButton.on 'mouseout', ->
        startGame.setStroke('#259bcb')
        document.body.style.cursor = 'default';
        buttonLayer.draw()

      buttonLayer.add(startGameButton)

      stage.add(buttonLayer)

      setTimeout =>
        baseLayer.draw()
        buttonLayer.draw() # otherwise the custom font doesn't draw (lame!)
      , 200

  return FrontPage
