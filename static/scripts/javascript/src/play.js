// Generated by CoffeeScript 1.4.0

define(['jquery', 'kinetic', 'async', 'tools'], function($, K, async, tools) {
  var PlayLevel, lightenDarkenColor, words;
  words = [
    {
      char: '狗肉',
      piny: 'gǒu ròu',
      ascii: 'gou rou',
      ans: '34',
      def: 'dog meat, something very stinky or repulsive'
    }, {
      char: '否則',
      piny: 'fǒu zé',
      ascii: 'fou ze',
      ans: '32',
      def: 'if not, otherwise, else, or else'
    }
  ];
  lightenDarkenColor = function(col, amt) {
    var b, g, num, r, usePound;
    usePound = false;
    if (col[0] === "#") {
      col = col.slice(1);
      usePound = true;
    }
    num = parseInt(col, 16);
    r = (num >> 16) + amt;
    if (r > 255) {
      r = 255;
    } else {
      if (r < 0) {
        r = 0;
      }
    }
    b = ((num >> 8) & 0x00FF) + amt;
    if (b > 255) {
      b = 255;
    } else {
      if (b < 0) {
        b = 0;
      }
    }
    g = (num & 0x0000FF) + amt;
    if (g > 255) {
      g = 255;
    } else {
      if (g < 0) {
        g = 0;
      }
    }
    return (usePound ? "#" : "") + (g | (b << 8) | (r << 16)).toString(16);
  };
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
      this.lastDrawnWord = false;
      this.currentSyllable = 0;
      this.scoreText = false;
      this.moving = false;
      this.mousePos = [];
      this.w = this.stage.getWidth();
      this.h = this.stage.getHeight();
      this.cardsLayer = new K.Layer();
      this.cardsLayer.add(new K.Rect({
        x: 0,
        y: 0,
        width: this.w,
        height: this.h
      }));
      this.drawCards(this.cardsLayer);
      this.scoreLayer = new K.Layer();
      this.drawScores(this.scoreLayer);
      this.drawTones(this.scoreLayer);
      this.drawActiveCard(this.cardsLayer);
      this.stage.add(this.cardsLayer);
      this.stage.add(this.scoreLayer);
      this.startListeners();
    }

    PlayLevel.prototype.drawScores = function(layer) {
      if (!this.scoreText) {
        this.scoreText = new K.Text({
          x: this.w * 0.05,
          y: this.h * 0.05,
          text: this.score,
          fontSize: this.h * 0.06,
          fontFamily: 'karatemedium',
          fill: 'white',
          align: 'left',
          width: this.w * 0.5,
          padding: 5
        });
        layer.add(this.scoreText);
      } else {
        this.scoreText.setText(this.score);
      }
      return layer.drawScene();
    };

    PlayLevel.prototype.drawTones = function(layer) {
      return console.log("draw tones");
    };

    PlayLevel.prototype.getCard = function(_arg) {
      var a, ascii, ascii_word, ascii_words, card, center, char, def, draggable, fullWord, height, left, name, numSyllables, paper, pickNewWord, randX, randY, top, totalAsciiWidth, w, width, word, _i, _j, _k, _ref, _ref1, _ref2,
        _this = this;
      name = _arg.name, draggable = _arg.draggable, word = _arg.word;
      if (draggable == null) {
        draggable = false;
      }
      pickNewWord = function() {
        return words[parseInt(Math.floor(Math.random() * words.length))];
      };
      if (word == null) {
        word = {};
      }
      if (this.lastDrawnWord) {
        console.log("has lastDrawnWord somehow...", this.lastDrawnWord);
        numSyllables = this.lastDrawnWord.ascii.split(" ").length;
        if (this.currentSyllable < numSyllables - 1) {
          this.currentSyllable += 1;
          word = this.lastDrawnWord;
        } else {
          word = pickNewWord();
          this.currentSyllable = 0;
        }
      } else {
        console.log("pick new word..");
        word = pickNewWord();
      }
      this.lastDrawnWord = word;
      console.log("word is", word, draggable);
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
        text: word.char.charAt(this.currentSyllable),
        fontSize: 0.75 * width * this.w,
        fontFamily: 'arial',
        fill: this.blackText,
        align: 'center',
        width: 0.75 * width * this.w,
        padding: 0
      });
      ascii = [];
      ascii_words = word.ascii.split(" ");
      totalAsciiWidth = 0;
      for (w = _i = 0, _ref = ascii_words.length; 0 <= _ref ? _i < _ref : _i > _ref; w = 0 <= _ref ? ++_i : --_i) {
        console.log(word, ascii_words[w]);
        ascii_word = new K.Text({
          y: top * this.h + 0.82 * width * this.w,
          x: (0.5 + randX * 0.05) * this.w + totalAsciiWidth,
          text: this.currentSyllable > w ? word.piny.split(" ")[w] : ascii_words[w],
          fontSize: 0.15 * width * this.w,
          fontFamily: 'arial',
          fontStyle: this.currentSyllable === w ? 'bold' : 'normal',
          fill: this.currentSyllable === w ? '#0000ff' : this.grayText,
          align: 'center',
          padding: 0
        });
        totalAsciiWidth += ascii_word.getWidth();
        ascii.push(ascii_word);
      }
      for (w = _j = 0, _ref1 = ascii.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; w = 0 <= _ref1 ? ++_j : --_j) {
        ascii[w].setX(ascii[w].getX() + (0.5 * width) - totalAsciiWidth / 2);
      }
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
      card.syllable = this.currentSyllable;
      card.add(paper);
      card.add(char);
      for (a = _k = 0, _ref2 = ascii.length; 0 <= _ref2 ? _k < _ref2 : _k > _ref2; a = 0 <= _ref2 ? ++_k : --_k) {
        card.add(ascii[a]);
      }
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
        card.moveToBottom();
        _results.push(console.log("draw card setting zindex", -this.cards.length - 1));
      }
      return _results;
    };

    PlayLevel.prototype.removeCard = function(card) {
      return card.remove();
    };

    PlayLevel.prototype.checkAnswer = function(tone, word, syllable, points) {
      console.log("checkAnswer", tone, word.ans);
      console.log(word.ans, word.syllable);
      if (tone === word.ans.charAt(syllable)) {
        this.score += 10 + this.combo - 1;
        this.combo += 1;
        if (this.combo % 5 === 0) {
          this.score += this.combo;
        }
        this.drawJiayou(word.ans.charAt(syllable), true, points);
        this.drawScores(this.scoreLayer);
        return true;
      } else {
        this.combo = 1;
        this.drawJiayou(word.ans.charAt(syllable), false, points);
      }
      return false;
    };

    PlayLevel.prototype.drawJiayou = function(tone, correct, points) {
      var comboNumber, comboText, comboWord, combos, cong, congrats, i, jiayou, jiayouStars, jiayouText, l, makeStar, newPoints, position, positions, slash, _i, _j, _ref, _ref1,
        _this = this;
      congrats = [
        {
          text: 'nice!',
          fill: '#11a7ff'
        }, {
          text: 'great!',
          fill: '#9e0aff'
        }, {
          text: '加油!',
          fill: '#00d66a'
        }, {
          text: 'excellent!',
          fill: '#00d66a'
        }, {
          text: '好棒喔!',
          fill: '#d60093'
        }
      ];
      combos = [
        {
          text: 'combo!',
          fill: '#00d66a'
        }, {
          text: 'epic!',
          fill: '#00d66a'
        }, {
          text: 'amazing!',
          fill: '#00d66a'
        }, {
          text: 'on fire!!',
          fill: '#00d66a'
        }
      ];
      cong = congrats[parseInt(Math.floor(Math.random() * congrats.length))];
      cong.fill = correct ? congrats[parseInt(tone)].fill : "#999999";
      positions = [
        {
          top: this.h * 0.9,
          left: this.w * 0.9 * Math.random()
        }, {
          top: this.h * (0.2 + 0.7 * Math.random()),
          left: this.w * 0.02
        }, {
          top: this.h * (0.2 + 0.7 * Math.random()),
          left: this.w * 0.82
        }
      ];
      position = positions[parseInt(Math.floor(Math.random() * positions.length))];
      if (correct) {
        jiayouText = new K.Text({
          x: position.left,
          y: position.top,
          offset: [160, 30],
          text: cong.text,
          fill: cong.fill,
          fontSize: this.h * 0.05,
          fontFamily: 'Calibri',
          fontStyle: 'bold italic',
          width: 380,
          padding: 20,
          align: 'center',
          shadowColor: 'black',
          shadowBlur: 2,
          shadowOffset: 4,
          shadowOpacity: 0.3,
          scale: {
            x: 1,
            y: 1
          }
        });
        makeStar = function(left, top) {
          var size, star;
          size = Math.random() * 1.0 + 0.5;
          star = new K.Star({
            x: left + Math.random() * 100 - 50,
            y: top + Math.random() * 100 - 50,
            innerRadius: size * 3,
            outerRadius: size * 6,
            numPoints: 5,
            fill: lightenDarkenColor(cong.fill, Math.random() * 100),
            stroke: 'none',
            shadowColor: 'black',
            strokeWidth: 0,
            shadowBlur: 2,
            shadowOffset: 4,
            shadowOpacity: 0.3
          });
          return star;
        };
        jiayouStars = (function() {
          var _i, _ref, _results;
          _results = [];
          for (_i = 0, _ref = parseInt(Math.random() * 3); 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--) {
            _results.push(makeStar(position.left, position.top));
          }
          return _results;
        })();
        jiayou = new K.Group();
        for (i = _i = 0, _ref = jiayouStars.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          jiayou.add(jiayouStars[i]);
        }
        comboText = false;
        if (this.combo % 5 === 0) {
          comboText = new K.Group();
          l = Math.max(10, positions[0].left - 200 * Math.random());
          comboWord = new K.Text({
            x: l,
            y: positions[0].top - 20,
            offset: [120, 30],
            text: combos[this.combo % combos.length].text,
            fill: cong.fill,
            fontSize: this.h * 0.06,
            fontFamily: 'Calibri',
            fontStyle: 'bold italic',
            width: 380,
            padding: 0,
            align: 'center',
            shadowColor: 'black',
            shadowBlur: 2,
            shadowOffset: 4,
            shadowOpacity: 0.3,
            scale: {
              x: 1,
              y: 1
            }
          });
          comboNumber = new K.Text({
            x: l - 5,
            y: positions[0].top - 20,
            offset: [120, 0],
            text: "+" + this.combo,
            fill: cong.fill,
            fontSize: this.h * 0.08,
            fontFamily: 'Arial',
            fontStyle: 'bold',
            width: 380,
            padding: 0,
            align: 'center',
            shadowColor: 'black',
            shadowBlur: 2,
            shadowOffset: 4,
            shadowOpacity: 0.3,
            scale: {
              x: 1,
              y: 1
            }
          });
          comboText.add(comboWord);
          comboText.add(comboNumber);
          comboText.setOffset([0, this.h * 0.1]);
        }
      }
      newPoints = $.extend(true, [], points);
      console.log("newpoints", newPoints);
      for (i = _j = _ref1 = points.length - 1; _ref1 <= 0 ? _j <= 0 : _j >= 0; i = _ref1 <= 0 ? ++_j : --_j) {
        newPoints.push({
          x: points[i].x,
          y: points[i].y + 20 * (points.length - i)
        });
      }
      slash = new K.Polygon({
        points: newPoints,
        stroke: 'none',
        strokeWidth: 0,
        scale: {
          x: 1.0,
          y: 1.0
        },
        fillLinearGradientStartPoint: [points[0].x, points[0].y],
        fillLinearGradientEndPoint: [points[points.length - 1].x, points[points.length - 1].y],
        fillLinearGradientColorStops: [0, lightenDarkenColor(cong.fill, 100), 1, cong.fill]
      });
      slash.setLineJoin('bevel');
      this.scoreLayer.add(slash);
      slash.transitionTo({
        scale: {
          x: 1.2,
          y: 1.2
        },
        opacity: 0.0,
        duration: 0.7,
        callback: function() {
          return slash.remove();
        }
      });
      if (correct) {
        this.scoreLayer.add(jiayou);
        this.scoreLayer.add(jiayouText);
        if (comboText) {
          this.scoreLayer.add(comboText);
          comboText.transitionTo({
            scale: {
              x: 1.4,
              y: 1.4
            },
            opacity: 0.1,
            duration: 1.5,
            callback: function() {
              return comboText.remove();
            }
          });
        }
        this.scoreLayer.drawScene();
        jiayou.transitionTo({
          scale: {
            x: 0.9,
            y: 0.9
          },
          opacity: 0.1,
          duration: 0.7,
          callback: function() {
            return jiayou.remove();
          }
        });
        return jiayouText.transitionTo({
          scale: {
            x: 1.5,
            y: 1.5
          },
          opacity: 0.1,
          duration: 0.7,
          callback: function() {
            return jiayouText.remove();
          }
        });
      }
    };

    PlayLevel.prototype.drawActiveCard = function(layer) {
      var card;
      this.activeCard = this.cards.shift();
      return card = this.activeCard;
    };

    PlayLevel.prototype.drawNewCard = function() {
      var newCard;
      console.log("drawNewCard");
      self.removeCard(self.activeCard);
      self.drawActiveCard(self.cardsLayer);
      console.log("drawNewCard 30");
      newCard = self.getCard({
        name: 'whatever' + Math.random(),
        draggable: false
      });
      self.cardsLayer.add(newCard);
      self.cards.push(newCard);
      console.log("new card setting zindex", -self.cards.length - 1);
      newCard.moveToBottom();
      console.log("new card setting active card zindex", -self.cards.length - 1);
      return console.log(self.cards, self.activeCard);
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
        opacity: 0.0,
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
          self.moving = true;
          return self.mousePos = [];
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
        var activeCard, ans, card, constY, corner, corner1, corner2, correct, m, m1, m2, mask1, mask2, mask3, maskTemplate, mousePos, moving, origin, p1, p2,
          _this = this;
        ans = '5';
        console.log("mouseup @@@");
        activeCard = self.activeCard;
        mousePos = self.mousePos;
        moving = self.moving;
        layer = self.cardsLayer;
        maskTemplate = {
          x: 0,
          y: 0,
          shadowColor: '#000000',
          shadowBlur: 50,
          shadowOffset: 0,
          shadowOpacity: 0.5
        };
        console.log("moving", moving);
        if (moving && mousePos.length > 3) {
          self.moving = false;
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
            ans = '3';
            correct = self.checkAnswer(ans, self.activeCard.word, self.activeCard.syllable, [p1, corner, p2]);
            console.log("CORRECT? ", correct);
            if (correct) {
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
              mask1 = new K.Polygon($.extend(maskTemplate, {
                points: [corner1.x, corner1.y, corner.x, corner.y, corner2.x, corner2.y]
              }));
              mask2 = new K.Polygon($.extend(maskTemplate, {
                points: [corner.x, corner.y, corner1.x, corner1.y, corner1.x, corner1.y + 500, corner.x, corner.y + 500]
              }));
              mask3 = new K.Polygon($.extend(maskTemplate, {
                points: [corner.x, corner.y, corner2.x, corner2.y, corner2.x, corner2.y + 500, corner.x, corner.y + 500]
              }));
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
                var clip1, clip2, clip3,
                  _this = this;
                console.log("clips", results);
                clip1 = results.clip1;
                clip2 = results.clip2;
                clip3 = results.clip3;
                self.flick(clip1, "top");
                self.flick(clip2, "bottom", "left");
                self.flick(clip3, "bottom", "right");
                layer.drawScene();
                setTimeout(function() {
                  self.removeCard(clip1);
                  self.removeCard(clip2);
                  return self.removeCard(clip3);
                }, 1000);
                return self.drawNewCard();
              });
            }
          } else {
            m = (p2.y - p1.y) / (p2.x - p1.x);
            if (m >= 0.2) {
              ans = '4';
            } else if (m <= -0.2) {
              ans = '2';
            } else {
              ans = '1';
            }
            correct = self.checkAnswer(ans, self.activeCard.word, self.activeCard.syllable, [p1, p2]);
            console.log("CORRECT? ", correct);
            if (correct) {
              card = {
                width: self.activeCard.getWidth(),
                height: self.activeCard.getHeight()
              };
              corner1 = {
                x: -20,
                y: m * (20 - (p1.x - origin.x)) + constY
              };
              corner2 = {
                x: 20 + card.width,
                y: m * (20 + card.width - (p1.x - origin.x)) + constY
              };
              mask1 = new K.Polygon($.extend(maskTemplate, {
                points: [corner1.x, corner1.y, -20, -20, card.width + 20, -20, corner2.x, corner2.y]
              }));
              mask2 = new K.Polygon($.extend(maskTemplate, {
                points: [corner1.x, corner1.y, 0, card.height, card.width, card.height, corner2.x, corner2.y]
              }));
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
                var clip1, clip2,
                  _this = this;
                console.log("clips", results);
                clip1 = results.clip1;
                clip2 = results.clip2;
                self.flick(clip1, "top");
                self.flick(clip2, "bottom");
                layer.drawScene();
                setTimeout(function() {
                  self.removeCard(clip1);
                  return self.removeCard(clip2);
                }, 1000);
                return self.drawNewCard();
              });
            }
          }
        }
        return moving = false;
      });
    };

    PlayLevel.prototype.getCorner = function(points) {
      var closest, corner, corners, endPoint, i, lastGradient, layer, m1, m2, mid, ms, prevGradient, startPoint, xdif, xdif1, xdif2;
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
          if (lastGradient <= 0.5 && prevGradient >= -0.5) {
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
        if (m1 >= 0.2 && m2 <= -0.2) {
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
