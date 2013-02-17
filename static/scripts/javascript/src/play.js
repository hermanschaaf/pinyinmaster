// Generated by CoffeeScript 1.4.0

define(['jquery', 'kinetic', 'tools'], function($, K, tools) {
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

    function PlayLevel(game, layer, level) {
      var baseLayer;
      this.game = game;
      this.layer = layer;
      baseLayer = this.layer;
      this.stage = this.game.stage;
      console.log("stage is", this.stage);
      this.w = this.stage.getWidth();
      this.h = this.stage.getHeight();
      this.scoreLayer = new K.Layer();
      this.drawScores(this.scoreLayer);
      this.cardsLayer = new K.Layer();
      this.drawCards(this.cardsLayer);
      this.drawActiveCard(this.cardsLayer);
      this.stage.add(this.scoreLayer);
      this.stage.add(this.cardsLayer);
    }

    PlayLevel.prototype.drawScores = function(layer) {
      var score;
      score = new K.Text({
        x: this.w * 0.05,
        y: this.h * 0.05,
        text: '1,000',
        fontSize: this.h * 0.1,
        fontFamily: 'karatemedium',
        fill: 'white',
        align: 'left',
        width: this.w * 0.5,
        padding: 5
      });
      return layer.add(score);
    };

    PlayLevel.prototype.getCard = function(_arg) {
      var card, char, draggable, name, paper, randX, randY, word;
      name = _arg.name, draggable = _arg.draggable, word = _arg.word;
      if (draggable == null) {
        draggable = false;
      }
      if (word == null) {
        word = words[parseInt(Math.floor(Math.random() * words.length))];
      }
      console.log(word, draggable);
      card = new K.Group({
        draggable: draggable
      });
      randX = Math.random();
      randY = Math.random();
      paper = tools.createRect({
        stage: this.stage,
        top: 0.2 + randY * 0.05,
        left: 0.5 + randX * 0.05,
        width: 0.8,
        marginLeft: -0.5,
        marginTop: 0.0,
        height: 'square',
        name: name,
        fill: '#f2f2ea',
        stroke: 'none',
        strokeWidth: 0
      });
      tools.addShadow(paper);
      char = new K.Text({
        y: (0.2 + randY * 0.05) * this.w,
        x: (0.5 + randX * 0.05) * this.w - (0.3 * this.w),
        text: word.char,
        fontSize: 0.6 * this.w,
        fontFamily: 'arial',
        fill: 'black',
        align: 'center',
        width: 0.6 * this.w,
        padding: this.w * 0.1
      });
      card.add(paper);
      card.add(char);
      card.setSize(paper.getSize());
      return card;
    };

    PlayLevel.prototype.drawCards = function(layer) {
      var card, i, _i, _results;
      console.log("now stage is", this.stage);
      this.cards = [];
      _results = [];
      for (i = _i = 0; _i <= 5; i = ++_i) {
        card = this.getCard({
          name: 'card' + i
        });
        this.cards.push(card);
        _results.push(layer.add(card));
      }
      return _results;
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
      }, 30);
    };

    PlayLevel.prototype.endDrag = function() {
      var dragEndPos, dragEndTime, numPositions, overThresholdX, overThresholdY, xFriction, xVel, yFriction, yVel,
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
      if (Math.abs(xVel) > 0.05) {
        console.log("flick off X, motherflicker!");
        overThresholdX = 1;
      }
      if (Math.abs(yVel) > 0.05) {
        console.log("flick off Y, motherflicker!");
        overThresholdY = 1;
      }
      console.log('xvel', xVel, overThresholdX, overThresholdY);
      if (overThresholdY || overThresholdX) {
        this.activeCard.transitionTo({
          x: this.activeCard.getX() + (xVel / Math.abs(xVel) * this.w) * overThresholdX,
          y: this.activeCard.getY() + (yVel / Math.abs(yVel) * this.h) * overThresholdY,
          duration: 0.2,
          easing: 'ease-out'
        });
        return setTimeout(function() {
          return _this.drawActiveCard(_this.cardsLayer);
        }, 0.1);
      }
    };

    PlayLevel.prototype.drawActiveCard = function(layer) {
      var card,
        _this = this;
      this.activeCard = this.cards.pop();
      card = this.activeCard;
      card.setDraggable(true);
      console.log("ACTIVE CARD IS", card);
      card.on('dragstart', function() {
        return _this.startDrag();
      });
      return card.on('dragend', function() {
        return _this.endDrag();
      });
    };

    return PlayLevel;

  })();
});
