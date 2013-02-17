
define [
    'jquery'
    'kinetic'
    'game'
    'tools'
    'waitfont'
], ($, K, game, tools) ->

  console.log "waiting for fonts"
  waitForWebfonts ['karatemedium'], ->
    console.log "fonts loaded!"
    layer = game.layer
    stage = game.stage
    w = stage.getWidth()
    h = stage.getHeight()

    group = new K.Group()


    logo = tools.createImage
      name: 'logo'
      src: 'static/images/logo.png'
      top: 0.2
      left: 0.5
      width: 1.0
      marginLeft: -0.5
      marginTop: -0.5

    laoshi = tools.createImage
      name: 'laoshi'
      src: 'static/images/laoshi.png'
      top: 0.95
      left: 0.5
      width: 0.5
      height: 0.5
      marginTop: -1.0
      marginLeft: 0.0

    ground = new K.Rect
      x: 0
      y: h * 0.9
      width: w
      height: h * 0.1
      name: 'ground'
      fill: '#170801'
      stroke: 'black'
      strokeWidth: 0

    startGame = tools.createRect
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

    startGame.setShadowBlur(50)
    startGame.setShadowColor('black')
    startGame.setShadowOffset([0, 0])
    startGame.setShadowOpacity(1.0)
    startGame.enableShadow()

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

    console.log "karatemedium"
    layer.add(ground)
    layer.add(startGame)
    layer.add(buttonText)
    console.log "added text"


    layer.draw()
    setTimeout =>
      layer.draw() # otherwise the custom font doesn't draw (lame!)
    , 100

    console.log "added!"