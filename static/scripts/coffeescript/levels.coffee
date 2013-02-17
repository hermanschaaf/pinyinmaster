define [
    'jquery'
    'kinetic'
    'tools'
], ($, K, tools) ->

  console.log "starting levels.coffee"

  levels = [{
    stars: 3,
    name: '一'
  }, 
  {
    stars: 3,
    name: '二'
  }, 
  {
    stars: 1,
    name: '三'
  }, 
  {
    stars: 2,
    name: '四'
  }, 
  {
    stars: 0,
    name: '五'
  }, 
  {
    stars: 0,
    name: '六'
  }, 
  {
    stars: 0,
    name: '七'
  },
  {
    stars: 0,
    name: '八'
  }, 
  {
    stars: 0,
    name: '九'
  } ] # todo: load from json or something


  class LevelsPage

    constructor: (@game, @layer) ->
      baseLayer = @layer
      stage = @game.stage
      w = stage.getWidth()
      h = stage.getHeight()

      logo = tools.createImage
        stage: stage
        name: 'logo'
        src: 'static/images/logo.png'
        top: 0.05
        left: 0.0
        width: 0.6
        marginLeft: 0.0
        marginTop: 0.0
        callback: (image) =>
          baseLayer.add(image)
          baseLayer.draw()

      levelsLayer = new K.Layer()

      for row in [0..2]
        for col in [0..2]
          i = row * 3 + col
          console.log i
          if i < levels.length
            level = levels[i]
            
            btn = new K.Group()

            width = w * 0.20
            height = width
            x = col * w * 0.25
            y = row * w * 0.25

            square = new K.Rect
              name: "level" + i
              x: x + (w - (2 * w * 0.25 + width)) / 2
              y: y + h * 0.2
              width: width
              height: height
              fill: "#f4f3ef"
              stroke: 'none'
              strokeWidth: 0
            
            buttonText = new K.Text
              x: x + (w - (2 * w * 0.25 + width)) / 2
              y: y + h * 0.2
              text: levels[i].name
              fontSize: parseInt(height * 0.65)
              fontFamily: 'karatemedium'
              fontStyle: 'bold'
              fill: 'black'
              align: 'center'
              width: width
              height: height*1.1
              padding: height * 0.2

            tools.addShadow(square)

            btn.add(square)
            btn.add(buttonText)

            btn.on 'mouseup touchup', ( (level) ->
              return ->
                $.event.trigger("request-level-start", [level])
            )(i)
            
            levelsLayer.add(btn)

      levelsLayer.draw()
      stage.add(levelsLayer)


  console.log "returning LevelsPage class"

  return LevelsPage
