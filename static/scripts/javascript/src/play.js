// Generated by CoffeeScript 1.4.0

define(['jquery', 'kinetic', 'async', 'tools'], function($, K, async, tools) {
  var PlayLevel, words;
  words = [
    {
      char: '你',
      piny: 'nǐ',
      ascii: 'ni',
      ans: '3',
      def: 'you'
    }, {
      char: '是',
      piny: 'shì',
      ascii: 'shi',
      ans: '4',
      def: 'is, to be'
    }, {
      char: '他',
      piny: 'tā',
      ascii: 'ta',
      ans: '1',
      def: 'him, he'
    }, {
      char: '狗肉',
      piny: 'gǒu ròu',
      ascii: 'gou rou',
      ans: '34',
      def: 'dog meat, something very stinky or repulsive'
    }, {
      char: '否',
      piny: 'fǒu',
      ascii: 'fou',
      ans: '3',
      def: 'otherwise, or else'
    }
  ];
  return PlayLevel = (function() {
    var self;

    self = PlayLevel;

    function PlayLevel(game, layer, level) {
      var baseLayer;
      this.game = game;
      this.layer = layer;
      self = this;
      baseLayer = this.layer;
      this.stage = this.game.stage;
      this.grayText = '#454545';
      this.blackText = '#000000';
      console.log("stage is", this.stage);
      this.playing = true;
      this.score = 1;
      this.combo = 1;
      this.moving = false;
      this.mousePos = [];
      this.w = this.stage.getWidth();
      this.h = this.stage.getHeight();
      this.scoreLayer = new K.Layer();
      this.drawScores(this.scoreLayer);
      this.drawTones(this.scoreLayer);
      this.cardsLayer = new K.Layer();
      this.cardsLayer.add(new K.Rect({
        x: 0,
        y: 0,
        width: this.w,
        height: this.h
      }));
      this.drawCards(this.cardsLayer);
      this.drawActiveCard(this.cardsLayer);
      this.stage.add(this.scoreLayer);
      this.stage.add(this.cardsLayer);
      this.startListeners();
    }

    PlayLevel.prototype.drawScores = function(layer) {
      var score;
      layer.removeChildren();
      score = new K.Text({
        x: this.w * 0.05,
        y: this.h * 0.05,
        text: this.score,
        fontSize: this.h * 0.1,
        fontFamily: 'karatemedium',
        fill: 'white',
        align: 'left',
        width: this.w * 0.5,
        padding: 5
      });
      layer.add(score);
      return layer.draw();
    };

    PlayLevel.prototype.drawTones = function(layer) {
      return console.log("draw tones");
    };

    PlayLevel.prototype.getCard = function(_arg) {
      var ascii, card, center, char, def, draggable, fullWord, height, left, name, paper, randX, randY, top, width, word,
        _this = this;
      name = _arg.name, draggable = _arg.draggable, word = _arg.word;
      if (draggable == null) {
        draggable = false;
      }
      if (word == null) {
        word = words[parseInt(Math.floor(Math.random() * words.length))];
      }
      console.log(word, draggable);
      card = new K.Group({
        draggable: draggable,
        name: 'group' + name
      });
      randX = Math.random();
      randY = Math.random();
      top = 0.2 + randY * 0.05;
      center = 0.5 + randX * 0.05;
      width = 0.8;
      height = 0.8;
      left = center - width * 0.5;
      paper = tools.createRect({
        stage: this.stage,
        top: top,
        left: left,
        width: width,
        marginLeft: 0,
        marginTop: 0.0,
        height: 'square',
        name: name,
        fill: '#f2f2ea',
        stroke: 'none',
        strokeWidth: 0
      });
      tools.addShadow(paper);
      char = new K.Text({
        y: top * this.h + 0.15 * width * this.w,
        x: center * this.w - (0.3 * this.w),
        text: word.char,
        fontSize: 0.75 * width * this.w,
        fontFamily: 'arial',
        fill: this.blackText,
        align: 'center',
        width: 0.75 * width * this.w,
        padding: 0
      });
      console.log('no padding 3');
      ascii = new K.Text({
        y: top * this.h + 0.82 * width * this.w,
        x: (0.5 + randX * 0.05) * this.w - (0.3 * this.w),
        text: word.ascii,
        fontSize: 0.15 * width * this.w,
        fontFamily: 'arial',
        fill: this.grayText,
        align: 'center',
        width: 0.6 * this.w,
        padding: 0
      });
      def = new K.Text({
        y: top * this.h,
        x: left * this.w,
        text: word.def,
        fontSize: Math.max(10, 0.04 * width * this.w),
        fontFamily: 'arial',
        fill: this.grayText,
        align: 'left',
        width: 0.5 * width * this.w,
        padding: 0.05 * width * this.w
      });
      fullWord = new K.Text({
        y: top * this.h,
        x: center * this.w,
        text: word.char,
        fontSize: 0.08 * width * this.w,
        fontFamily: 'arial',
        fill: this.grayText,
        align: 'right',
        width: 0.5 * width * this.w,
        padding: 0.05 * width * this.w
      });
      card.word = word;
      card.add(paper);
      card.add(char);
      card.add(ascii);
      card.add(def);
      card.add(fullWord);
      card.getX = function() {
        return left * _this.w;
      };
      card.getY = function() {
        return top * _this.h;
      };
      card.getWidth = function() {
        return width * _this.w;
      };
      card.getHeight = function() {
        return width * _this.w;
      };
      card.setSize(paper.getSize());
      return card;
    };

    PlayLevel.prototype.drawCards = function(layer) {
      var card, i, _i, _results;
      console.log("now stage is", this.stage);
      this.cards = [];
      _results = [];
      for (i = _i = 0; _i <= 1; i = ++_i) {
        card = this.getCard({
          name: 'card' + i
        });
        this.cards.push(card);
        layer.add(card);
        _results.push(card.setZIndex(-this.cards.length));
      }
      return _results;
    };

    PlayLevel.prototype.removeCard = function(layer, card) {
      var c;
      console.log(layer);
      console.log(card);
      c = layer.get(card.getName());
      card.remove();
      return console.log(card);
    };

    PlayLevel.prototype.startDrag = function() {
      var _this = this;
      this.dragStartTime = (new Date()).getTime();
      this.dragPositions = [
        {
          x: this.activeCard.getX(),
          y: this.activeCard.getY()
        }
      ];
      return this.dragInterval = setInterval(function() {
        _this.dragStartTime = (new Date()).getTime();
        _this.dragPositions.push({
          x: _this.activeCard.getX(),
          y: _this.activeCard.getY()
        });
        if (_this.dragPositions.length > 3) {
          return _this.dragPositions.slice(0, 1);
        }
      }, 50);
    };

    PlayLevel.prototype.endDrag = function() {
      var ans, bottomTime, c, dragEndPos, dragEndTime, finalXPos, finalYPos, leftTime, numPositions, overThresholdX, overThresholdY, rightTime, topTime, v, xFriction, xVel, yFriction, yVel,
        _this = this;
      clearInterval(this.dragInterval);
      dragEndTime = (new Date()).getTime();
      dragEndPos = {
        x: this.activeCard.getX(),
        y: this.activeCard.getY()
      };
      numPositions = this.dragPositions.length;
      xVel = 0;
      yVel = 0;
      if (numPositions >= 2) {
        xVel = (this.dragPositions[numPositions - 1].x - this.dragPositions[numPositions - 2].x) / 0.1;
        yVel = (this.dragPositions[numPositions - 1].y - this.dragPositions[numPositions - 2].y) / 0.1;
      } else {
        xVel = (this.dragPositions[0].x - dragEndPos.x) * 1000.0 / (this.dragStartTime - dragEndTime);
        yVel = (this.dragPositions[0].y - dragEndPos.y) * 1000.0 / (this.dragStartTime - dragEndTime);
      }
      xVel = xVel / this.w;
      yVel = yVel / this.h;
      console.log(xVel, yVel);
      xFriction = 0.20;
      yFriction = 0.20;
      overThresholdX = 0;
      overThresholdY = 0;
      if (Math.abs(xVel) > 0.1) {
        console.log("flick off X, motherflicker!");
        overThresholdX = 1;
      }
      if (Math.abs(yVel) > 0.1) {
        console.log("flick off Y, motherflicker!");
        overThresholdY = 1;
      }
      if (overThresholdY || overThresholdX) {
        finalXPos = xVel * 3;
        finalYPos = yVel * 3;
        finalXPos = finalXPos < 2.0 && finalXPos > 0.0 ? 2.0 : finalXPos > -2.0 && finalXPos < 0.0 ? -2.0 : finalXPos;
        finalYPos = finalYPos < 2.0 && finalYPos > 0.0 ? 2.0 : finalYPos > -2.0 && finalYPos < 0.0 ? -2.0 : finalYPos;
        this.activeCard.transitionTo({
          x: this.activeCard.getX() + (finalXPos * this.w) * overThresholdX,
          y: this.activeCard.getY() + (finalYPos * this.h) * overThresholdY,
          duration: 0.2,
          easing: 'ease-in-out'
        });
        c = {
          x: this.activeCard.getX() + this.activeCard.getWidth() / 2,
          y: this.activeCard.getY() + this.activeCard.getHeight() / 2
        };
        v = {
          x: xVel,
          y: yVel
        };
        console.log(c.y, v.y);
        topTime = v.y !== 0 ? (0 - c.y) / v.y : -1;
        console.log("Top Time is", topTime);
        bottomTime = v.y !== 0 ? (this.h - c.y) / v.y : -1;
        console.log("Bottom Time is", bottomTime);
        leftTime = v.x !== 0 ? (0 - c.x) / v.x : -1;
        rightTime = v.x !== 0 ? (-this.w - c.x) / v.x : -1;
        console.log("topTime", topTime, "bottomTime", bottomTime);
        ans = '0';
        if (v.y < 0) {
          if (Math.abs(v.x) > Math.abs(v.y)) {
            if (v.x < 0) {
              console.log("LEFT!");
              ans = '1';
            } else {
              console.log("RIGHT!");
              ans = '3';
            }
          } else {
            console.log("TOP!");
            ans = '2';
          }
        } else {
          if (Math.abs(v.x) > Math.abs(v.y)) {
            if (v.x < 0) {
              console.log("LEFT!");
              ans = '1';
            } else {
              console.log("RIGHT!");
              ans = '3';
            }
          } else {
            console.log("BOTTOM!");
            ans = '4';
          }
        }
        this.checkAnswer(ans, this.activeCard.word);
        setTimeout(function() {
          var newCard;
          _this.removeCard(_this.cardsLayer, _this.activeCard);
          newCard = _this.getCard({
            name: 'whatever' + Math.random(),
            draggable: false
          });
          _this.cardsLayer.add(newCard);
          _this.cards.push(newCard);
          newCard.setZIndex(-_this.cards.length);
          return _this.bottomStack -= 1;
        }, 100);
        return setTimeout(function() {
          return _this.drawActiveCard(_this.cardsLayer);
        }, 100);
      }
    };

    PlayLevel.prototype.checkAnswer = function(tone, word) {
      console.log("checkAnswer", tone, word.ans);
      if (tone === word.ans.charAt(0)) {
        this.score += 1 * parseInt(Math.max(this.combo / 2, 1));
        this.combo += 1;
        this.drawScores(this.scoreLayer);
        this.drawGlow(word.ans.charAt(0), true);
        return console.log(this.score);
      } else {
        this.combo = 1;
        return this.drawGlow(tone, false);
      }
    };

    PlayLevel.prototype.drawGlow = function(tone, correct) {
      var glow;
      glow = false;
      if (tone === '4') {
        glow = new K.Rect({
          x: 0,
          y: 0,
          width: this.w,
          height: 10,
          fill: correct ? "#00ff00" : "#ff0000",
          stroke: 'none'
        });
      }
      if (tone === '3') {
        glow = new K.Rect({
          x: this.w - 10,
          y: 0,
          width: 10,
          height: this.h,
          fill: correct ? "#00ff00" : "#ff0000",
          stroke: 'none'
        });
      }
      if (tone === '4') {
        glow = new K.Rect({
          x: 0,
          y: this.h - 10,
          width: this.w,
          height: 10,
          fill: correct ? "#00ff00" : "#ff0000",
          stroke: 'none'
        });
      }
      if (tone === '1') {
        glow = new K.Rect({
          x: 0,
          y: 0,
          width: 10,
          height: this.h,
          fill: correct ? "#00ff00" : "#ff0000",
          stroke: 'none'
        });
      }
      if (glow) {
        this.scoreLayer.clear();
        this.scoreLayer.add(glow);
        this.scoreLayer.draw();
        return console.log("GLOW IS", glow);
      }
    };

    PlayLevel.prototype.drawActiveCard = function(layer) {
      var card;
      this.activeCard = this.cards.shift();
      return card = this.activeCard;
    };

    PlayLevel.prototype.clip = function(shape, mask, callback) {
      var cb;
      cb = function(img) {
        mask.setFillPatternImage(img);
        console.log("CLIPPING MF");
        console.log(mask.getOffset(), shape.getOffset(), shape.getX(), shape.getY(), shape.x, shape.y);
        mask.setX(shape.getX() + mask.getOffset().x);
        mask.setY(shape.getY() + mask.getOffset().y);
        mask.setFillPatternOffset({
          x: mask.getOffset().x + shape.getX(),
          y: mask.getOffset().y + shape.getY()
        });
        mask.setFillPatternRepeat("no-repeat");
        console.log("calling callback!");
        return callback(null, mask);
      };
      return console.log(shape.toImage({
        callback: cb
      }));
    };

    PlayLevel.prototype.flick = function(shape, direction, sideWays) {
      var dir;
      dir = (direction === "top" ? -1 : 1);
      if (sideWays) {
        sideWays = (sideWays === "left" ? -1 : 1);
      } else {
        sideWays = 0;
      }
      console.log("width is", shape.getWidth(), shape.getHeight());
      return shape.transitionTo({
        x: shape.getX() + 100 + Math.random() * 100 + sideWays * Math.random() * 1000,
        y: (direction === "top" ? -500 - Math.max(shape.getWidth(), shape.getHeight()) * 1.41 : self.h + 100),
        rotation: Math.random() * 2,
        duration: 1
      });
    };

    PlayLevel.prototype.startListeners = function() {
      var layer, stage;
      if (typeof console !== "undefined" && console !== null) {
        console.log("adding listeners");
      }
      this.moving = false;
      this.mousePos = [];
      stage = this.stage;
      layer = this.cardsLayer;
      stage.on("mousedown", function(e) {
        console.log("mousedown @@@");
        if (self.moving) {
          return self.moving = false;
        } else {
          self.mousePos = [];
          return self.moving = true;
        }
      });
      stage.on("mousemove", function(e) {
        if (self.moving) {
          self.mousePos.push(stage.getMousePosition());
          return self.moving = true;
        }
      });
      return stage.on("mouseup", function() {
        var activeCard, card, constY, corner, corner1, corner2, m, m1, m2, mask1, mask2, mask3, mousePos, moving, origin, p1, p2,
          _this = this;
        console.log("mouseup @@@");
        activeCard = self.activeCard;
        mousePos = self.mousePos;
        moving = self.moving;
        layer = self.cardsLayer;
        console.log("moving", moving);
        if (moving) {
          moving = false;
          console.log(self, self.activeCard);
          origin = {
            x: self.activeCard.getX(),
            y: self.activeCard.getY()
          };
          p1 = mousePos[0];
          p2 = mousePos[mousePos.length - 1];
          constY = p1.y - origin.y;
          corner = self.getCorner(mousePos);
          if (corner) {
            console.log("third!");
            m1 = (corner.y - p1.y) / (corner.x - p1.x);
            m2 = (p2.y - corner.y) / (p2.x - corner.x);
            corner1 = {
              x: -200,
              y: m1 * (-200 - (corner.x - origin.x)) + constY
            };
            corner2 = {
              x: 400,
              y: m2 * (400 - (corner.x - origin.x)) + constY
            };
            mask1 = new K.Polygon({
              points: [corner1.x, corner1.y, corner.x, corner.y, corner2.x, corner2.y]
            });
            mask2 = new K.Polygon({
              points: [corner.x, corner.y, corner1.x, corner1.y, corner1.x, corner1.y + 500, corner.x, corner.y + 500],
              x: 0,
              y: 0
            });
            mask3 = new K.Polygon({
              points: [corner.x, corner.y, corner2.x, corner2.y, corner2.x, corner2.y + 500, corner.x, corner.y + 500],
              x: 0,
              y: 0
            });
            console.log(mask1);
            layer.add(mask1);
            layer.add(mask2);
            layer.add(mask3);
            async.parallel({
              clip1: function(done) {
                console.log("clip1..");
                return self.clip(self.activeCard, mask1, done);
              },
              clip2: function(done) {
                return self.clip(self.activeCard, mask2, done);
              },
              clip3: function(done) {
                return self.clip(self.activeCard, mask3, done);
              }
            }, function(err, results) {
              var clip1, clip2, clip3;
              console.log("clips", results);
              clip1 = results.clip1;
              clip2 = results.clip2;
              clip3 = results.clip3;
              self.flick(clip1, "top");
              self.flick(clip2, "bottom", "left");
              self.flick(clip3, "bottom", "right");
              self.activeCard.remove();
              return layer.drawScene();
            });
          } else {
            m = (p2.y - p1.y) / (p2.x - p1.x);
            if (m >= 0.3) {
              console.log("fourth!");
            } else if (m <= -0.3) {
              console.log("second!");
            } else {
              console.log("first!");
            }
            card = {
              width: self.activeCard.getWidth(),
              height: self.activeCard.getHeight()
            };
            corner1 = {
              x: 0,
              y: m * (0 - (p1.x - origin.x)) + constY
            };
            corner2 = {
              x: 0 + card.width,
              y: m * (card.width - (p1.x - origin.x)) + constY
            };
            mask1 = new K.Polygon({
              points: [corner1.x, corner1.y, 0, 0, card.width, 0, corner2.x, corner2.y],
              x: 0,
              y: 0,
              stroke: 'red',
              strokeWidth: 5
            });
            mask2 = new K.Polygon({
              points: [corner1.x, corner1.y, 0, card.height, card.width, card.height, corner2.x, corner2.y],
              x: 0,
              y: 0,
              stroke: 'red',
              strokeWidth: 5
            });
            layer.add(mask1);
            layer.add(mask2);
            async.parallel({
              clip1: function(done) {
                return self.clip(self.activeCard, mask1, done);
              },
              clip2: function(done) {
                return self.clip(self.activeCard, mask2, done);
              }
            }, function(err, results) {
              var clip1, clip2;
              console.log("clips", results);
              clip1 = results.clip1;
              clip2 = results.clip2;
              self.flick(clip1, "top");
              self.flick(clip2, "bottom");
              self.activeCard.remove();
              return layer.drawScene();
            });
          }
        }
        return moving = false;
      });
    };

    PlayLevel.prototype.getCorner = function(points) {
      var closest, corner, corners, endPoint, i, lastGradient, layer, m1, m2, mid, ms, point, prevGradient, startPoint, xdif, xdif1, xdif2;
      layer = self.cardsLayer;
      ms = [];
      corners = [];
      startPoint = points[0];
      endPoint = points[points.length - 1];
      i = 3;
      while (i < points.length - 3) {
        xdif = points[i + 1].x - points[i].x;
        ms.push((points[i + 1].y - points[i].y) / (xdif === 0 ? 0.000001 : xdif));
        console.log(ms[ms.length - 1], ms[ms.length - 2]);
        if (i > 0 && i < points.length - 1) {
          lastGradient = ms[ms.length - 1];
          prevGradient = ms[ms.length - 1];
          point = new Kinetic.Circle({
            x: points[i].x,
            y: points[i].y,
            radius: 5,
            stroke: (lastGradient >= 0 ? "blue" : "green"),
            strokeWidth: 1
          });
          layer.add(point);
          layer.drawScene();
          if (lastGradient <= 0.3 && prevGradient >= -0.3) {
            corners.push(i);
          }
        }
        i++;
      }
      mid = points.length / 2;
      closest = 0;
      i = 0;
      while (i < corners.length) {
        if (Math.abs(corners[closest] - mid) > Math.abs(corners[i] - mid)) {
          closest = i;
        }
        i++;
      }
      if (corners.length > 0) {
        corner = points[corners[closest]];
        xdif1 = corner.x - points[0].x;
        m1 = (corner.y - points[0].y) / (xdif1 === 0 ? 0.000001 : xdif1);
        xdif2 = corner.x - points[points.length - 1].x;
        m2 = (corner.y - points[points.length - 1].y) / (xdif2 === 0 ? 0.000001 : xdif2);
        if (m1 >= 0.3 && m2 <= -0.3) {
          point = new Kinetic.Circle({
            x: points[corners[closest]].x,
            y: points[corners[closest]].y,
            radius: 10,
            stroke: "red",
            strokeWidth: 5
          });
          layer.add(point);
          return corner;
        }
      }
      return false;
    };

    PlayLevel.prototype.selectTone = function() {
      var difX, difY;
      difX = mousePos2.x - mousePos1.x;
      difY = mousePos2.y - mousePos1.y;
      if (Math.abs(mousePosMax.difY) <= Math.abs(difY) + 10) {
        if (difY > 50 && difX > 50) {
          console.log("fourth!");
          return '4';
        }
        if (difY < -50 && difX > 50) {
          console.log("second!");
          return '2';
        }
      }
      if (difX > 50 || difX < -50) {
        if (mousePosMax.difY > 20 && mousePosMax.y - mousePos2.y > 20) {
          console.log("third!");
          return '3';
        } else {
          console.log("first!");
          return '1';
        }
      }
      return '5';
    };

    return PlayLevel;

  })();
});
