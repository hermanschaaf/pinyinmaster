define [
    'jquery'
    'kinetic'
    'game'
], ($, K, game) ->

  h = game.height
  w = game.width
  layer = game.layer

  return {
    createImage: ({name, src, top, left, width, height, marginLeft, marginTop}) -> 
      # src: path or url to image
      # top: decimal between 0.0 and 1.0 (0% - 100%)
      # left, width, height: same as `top`
      top ?= 0.0
      left ?= 0.0
      width ?= 1.0
      height ?= 1.0
      marginLeft ?= 0.0
      marginTop ?= 0.0

      imageObj = new Image()
      imageObj.onload = ->

        scalingFactorW = Math.min(1.0, w * width / imageObj.width)
        scalingFactorH = Math.min(1.0, w * height / imageObj.height)
        scalingFactor = Math.min(scalingFactorW, scalingFactorH)

        img = new K.Image
          x: w * left + imageObj.width * scalingFactor * marginLeft
          y: h * top + imageObj.height * scalingFactor * marginTop
          width: scalingFactor * imageObj.width
          height: scalingFactor * imageObj.height
          image: imageObj
          name: name

        # add the shape to the layer
        layer.add(img)
        layer.draw()

      imageObj.src = src

    , createRect: ({name, top, left, width, height, marginLeft, marginTop, fill, stroke, strokeWidth}) -> 
      top ?= 0.0
      left ?= 0.0
      width ?= 1.0
      height ?= 1.0
      marginLeft ?= 0.0
      marginTop ?= 0.0

      scalingFactor = 1.0

      rect = new K.Rect
        x: w * left + w * width * scalingFactor * marginLeft
        y: h * top + h * height * scalingFactor * marginTop
        width: if width <= 1.0 then w * width else width
        height: if height <= 1.0 then h * height else height 
        name: name
        stroke: stroke
        strokeWidth: strokeWidth
        fill: fill

      return rect
  }