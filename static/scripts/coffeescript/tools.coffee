define [
    'jquery'
    'kinetic'
], ($, K) ->

  return {
    createImage: ({stage, name, src, top, left, width, height, marginLeft, marginTop, callback}) -> 
      # src: path or url to image
      # top: decimal between 0.0 and 1.0 (0% - 100%)
      # left, width, height: same as `top`

      h = stage.getHeight()
      w = stage.getWidth()

      top ?= 0.0
      left ?= 0.0
      width ?= 1.0
      height ?= 1.0
      marginLeft ?= 0.0
      marginTop ?= 0.0

      imageObj = new Image()
      imageObj.onload = =>

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

        callback(img)
        
      imageObj.src = src


    , createRect: ({stage, name, top, left, width, height, marginLeft, marginTop, fill, stroke, strokeWidth}) -> 
      top ?= 0.0
      left ?= 0.0
      width ?= 1.0
      height ?= 1.0
      marginLeft ?= 0.0
      marginTop ?= 0.0

      h = stage.getHeight()
      w = stage.getWidth()

      scalingFactor = 1.0

      width = if width <= 1.0 then w * width else width
      if height == 'square'
        height = width
      else
        height = if height <= 1.0 then h * height else height

      rect = new K.Rect
        x: w * left + width * marginLeft
        y: h * top + height * marginTop
        width: width
        height: height
        name: name
        stroke: stroke
        strokeWidth: strokeWidth
        fill: fill

      console.log rect.attrs.x

      return rect
    ,

    addShadow: (el) ->
      el.setShadowBlur(50)
      el.setShadowColor('black')
      el.setShadowOffset([0, 0])
      el.setShadowOpacity(1.0)
      el.enableShadow()
  }