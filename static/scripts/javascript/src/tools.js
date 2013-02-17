// Generated by CoffeeScript 1.4.0

define(['jquery', 'kinetic', 'game'], function($, K, game) {
  var h, layer, w;
  h = game.height;
  w = game.width;
  layer = game.layer;
  return {
    createImage: function(_arg) {
      var height, imageObj, left, marginLeft, marginTop, name, src, top, width;
      name = _arg.name, src = _arg.src, top = _arg.top, left = _arg.left, width = _arg.width, height = _arg.height, marginLeft = _arg.marginLeft, marginTop = _arg.marginTop;
      if (top == null) {
        top = 0.0;
      }
      if (left == null) {
        left = 0.0;
      }
      if (width == null) {
        width = 1.0;
      }
      if (height == null) {
        height = 1.0;
      }
      if (marginLeft == null) {
        marginLeft = 0.0;
      }
      if (marginTop == null) {
        marginTop = 0.0;
      }
      imageObj = new Image();
      imageObj.onload = function() {
        var img, scalingFactor, scalingFactorH, scalingFactorW;
        scalingFactorW = Math.min(1.0, w * width / imageObj.width);
        scalingFactorH = Math.min(1.0, w * height / imageObj.height);
        scalingFactor = Math.min(scalingFactorW, scalingFactorH);
        img = new K.Image({
          x: w * left + imageObj.width * scalingFactor * marginLeft,
          y: h * top + imageObj.height * scalingFactor * marginTop,
          width: scalingFactor * imageObj.width,
          height: scalingFactor * imageObj.height,
          image: imageObj,
          name: name
        });
        layer.add(img);
        return layer.draw();
      };
      return imageObj.src = src;
    },
    createRect: function(_arg) {
      var fill, height, left, marginLeft, marginTop, name, rect, scalingFactor, stroke, strokeWidth, top, width;
      name = _arg.name, top = _arg.top, left = _arg.left, width = _arg.width, height = _arg.height, marginLeft = _arg.marginLeft, marginTop = _arg.marginTop, fill = _arg.fill, stroke = _arg.stroke, strokeWidth = _arg.strokeWidth;
      if (top == null) {
        top = 0.0;
      }
      if (left == null) {
        left = 0.0;
      }
      if (width == null) {
        width = 1.0;
      }
      if (height == null) {
        height = 1.0;
      }
      if (marginLeft == null) {
        marginLeft = 0.0;
      }
      if (marginTop == null) {
        marginTop = 0.0;
      }
      scalingFactor = 1.0;
      rect = new K.Rect({
        x: w * left + w * width * scalingFactor * marginLeft,
        y: h * top + h * height * scalingFactor * marginTop,
        width: width <= 1.0 ? w * width : width,
        height: height <= 1.0 ? h * height : height,
        name: name,
        stroke: stroke,
        strokeWidth: strokeWidth,
        fill: fill
      });
      return rect;
    }
  };
});
