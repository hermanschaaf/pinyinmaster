define [
    'jquery'
    'kinetic'
    'tools'
], ($, K, tools) ->

  # static vars (to be loaded with ajax/json)
  words = [
    char: '你'
    piny: 'nǐ' 
    ascii: 'ni'
    ans: '3'
    def: 'you'
  ,
    char: '是'
    piny: 'shì'
    ascii: 'shi'
    ans: '4'
    def: 'is, to be'
  ,
    char: '他'
    piny: 'tā'
    ascii: 'ta'
    ans: '1'
    def: 'him, he'
  ,
    char: '狗肉'
    piny: 'gǒu ròu'
    ascii: 'gou rou'
    ans: '34'
    def: 'dog meat, something very stinky or repulsive'
  ,
    char: '否'
    piny: 'fǒu'
    ascii: 'fou'
    ans: '3'
    def: 'otherwise, or else'
  ]

  class PlayLevel

    constructor: (@game, @layer, level) ->
      baseLayer = @layer
      @stage = @game.stage

      @grayText = '#454545'
      @blackText = '#000000'

      console.log "stage is", @stage

      @playing = true
      @score = 1
      @combo = 1
      @bottomStack = -1

      @w = @stage.getWidth()
      @h = @stage.getHeight()

      @scoreLayer = new K.Layer()
      @drawScores(@scoreLayer)
      @drawTones(@scoreLayer)

      @cardsLayer = new K.Layer()
      @drawCards(@cardsLayer)

      #@activeLayer = new K.Layer()
      @drawActiveCard(@cardsLayer)

      @stage.add(@scoreLayer)
      @stage.add(@cardsLayer)
      #@stage.add(@activeLayer)

    drawScores: (layer) ->
      layer.removeChildren()
      score = new K.Text
        x: @w * 0.05
        y: @h * 0.05
        text: @score
        fontSize: @h * 0.1
        fontFamily: 'karatemedium'
        fill: 'white'
        align: 'left'
        width: @w * 0.5
        padding: 5
      layer.add(score)
      layer.draw()

    drawTones: (layer) ->
      console.log "draw tones"

    getCard: ({name, draggable, word, bottom}) ->
      draggable ?= false
      word ?= words[parseInt(Math.floor(Math.random() * words.length))]
      bottom ?= true

      console.log word, draggable

      card = new K.Group(
        draggable: draggable
        name: 'group'+name
        zIndex: @bottomStack
      ) 
      @bottomStack -= 1

      randX = Math.random()
      randY = Math.random()

      top = 0.2 + randY * 0.05
      center = 0.5 + randX * 0.05
      width = 0.8
      height = 0.8
      left = center - width * 0.5

      paper = tools.createRect
        stage: @stage
        top: top
        left: left
        width: width
        marginLeft: 0
        marginTop: 0.0
        height: 'square'
        name: name
        fill: '#f2f2ea'
        stroke: 'none'
        strokeWidth: 0
      tools.addShadow(paper)

      char = new K.Text
        y: top * @h + 0.15 * width * @w
        x: center * @w - (0.3 * @w)
        text: word.char
        fontSize: 0.75 * width * @w # 3/4 of card
        fontFamily: 'arial'
        fill: @blackText
        align: 'center'
        width: 0.75 * width * @w  # 3/4 of card width
        padding:  0 # 0.25 * width * @w # 25 % of card

      console.log 'no padding 3'

      ascii = new K.Text
        y: top * @h + 0.82 * width * @w
        x: (0.5 + randX * 0.05) * @w - (0.3 * @w)
        text: word.ascii
        fontSize: 0.15 * width * @w
        fontFamily: 'arial'
        fill: @grayText
        align: 'center'
        width: 0.6 * @w
        padding: 0

      def = new K.Text
        y: top * @h
        x: left * @w
        text: word.def
        fontSize: Math.max(10, 0.04 * width * @w)
        fontFamily: 'arial'
        fill: @grayText
        align: 'left'
        width: 0.5 * width * @w
        padding: 0.05 * width * @w

      fullWord = new K.Text
        y: top * @h
        x: center * @w
        text: word.char
        fontSize: 0.08 * width * @w
        fontFamily: 'arial'
        fill: @grayText
        align: 'right'
        width: 0.5 * width * @w
        padding: 0.05 * width * @w

      card.word = word
      card.add(paper)
      card.add(char)
      card.add(ascii)
      card.add(def)
      card.add(fullWord)
      card.setSize(paper.getSize())

      return card

    drawCards: (layer) ->
      console.log "now stage is", @stage
      @cards = []
      for i in [0..5]
        card = @getCard({name: 'card'+i})
        @cards.push(card)

        layer.add(card)

    removeCard: (layer, card) ->
      console.log layer
      console.log card
      c = layer.get(card.getName())
      card.remove()
      console.log card
      #layer.remove(card.getName())

    startDrag: ->
      @dragStartTime = (new Date()).getTime()
      @dragPositions = [
        x: @activeCard.getX()
        y: @activeCard.getY()
      ]
      @dragInterval = setInterval =>
        @dragStartTime = (new Date()).getTime()
        @dragPositions.push
          x: @activeCard.getX()
          y: @activeCard.getY()
        if @dragPositions.length > 3
          @dragPositions.slice(0,1)
      , 50

    endDrag: ->
      clearInterval(@dragInterval)
      dragEndTime = (new Date()).getTime()
      dragEndPos = 
        x: @activeCard.getX()
        y: @activeCard.getY()

      numPositions = @dragPositions.length
      xVel = 0
      yVel = 0
      if numPositions >= 2
        xVel = (( @dragPositions[numPositions-1].x - @dragPositions[numPositions-2].x ) / 0.1)
        yVel = (( @dragPositions[numPositions-1].y - @dragPositions[numPositions-2].y ) / 0.1)
      else
        xVel = (( @dragPositions[0].x - dragEndPos.x ) * 1000.0 / (@dragStartTime - dragEndTime))
        yVel = (( @dragPositions[0].y - dragEndPos.y ) * 1000.0 / (@dragStartTime - dragEndTime))

      # get velocities as percentage of screen width and height
      xVel = xVel / @w
      yVel = yVel / @h

      console.log xVel, yVel

      # now we have the velocity of the last ~50ms of the drag, 
      # extrapolate the speed and flick the card off the screen
      # if the speed is over a certain threshold

      xFriction = 0.20 # final velocity as percentage of screen dimestions
      yFriction = 0.20

      overThresholdX = 0
      overThresholdY = 0

      if Math.abs(xVel) > 0.1
        console.log "flick off X, motherflicker!"
        overThresholdX = 1
        
      if Math.abs(yVel) > 0.1
        console.log "flick off Y, motherflicker!"
        overThresholdY = 1 

      if overThresholdY or overThresholdX
        finalXPos = xVel * 3
        finalYPos = yVel * 3
        finalXPos = if finalXPos < 2.0 and finalXPos > 0.0 then 2.0 else if finalXPos > -2.0 and finalXPos < 0.0 then -2.0 else finalXPos
        finalYPos = if finalYPos < 2.0 and finalYPos > 0.0 then 2.0 else if finalYPos > -2.0 and finalYPos < 0.0 then -2.0 else finalYPos
        @activeCard.transitionTo
          x: @activeCard.getX() + (finalXPos * @w ) * overThresholdX
          y: @activeCard.getY() + (finalYPos * @h ) * overThresholdY
          duration: 0.2
          easing: 'ease-in-out'

        # to calculate the answer, we need to calculate
        # the intersection of the center of the card with
        # the corners of the screen on its way out. Fun!

        # get the center of the card
        c = 
          x: @activeCard.getX() + @activeCard.getWidth() / 2
          y: @activeCard.getY() + @activeCard.getHeight() / 2

        # velocity shortcut
        v = 
          x: xVel
          y: yVel

        # so at time t, center of card is at:
        # x(t) = c.x + v.x * t
        # y(t) = c.y + v.y * t

        # we want to know whether t is positive or negative
        # at the time of crossing certain boundaries
        # -> this will tell us whether it will or will not cross, 
        # respectively

        # so:
        # t = (x - c.x) / v.x
        # t = (y - c.y) / v.y

        # check intersection with top line (when y = 0):
        console.log c.y, v.y
        topTime = if v.y != 0 then (0 - c.y) / v.y else -1
        #exitTop = topTime >= 0 and topTime <= 200
        console.log "Top Time is", topTime

        bottomTime = if v.y != 0 then (@h - c.y) / v.y else -1
        #exitBottom = bottomTime >= 0 and bottomTime <= 200
        console.log "Bottom Time is", bottomTime

        leftTime = if v.x != 0 then (0 - c.x) / v.x else -1
        #exitLeft = leftTime >= 0 and leftTime <= 200

        rightTime = if v.x != 0 then (-@w - c.x) / v.x else -1
        #exitRight = rightTime >= 0 and rightTime <= 200

        console.log "topTime", topTime, "bottomTime", bottomTime

        ans = '0'

        if v.y < 0
          # top
          if Math.abs(v.x) > Math.abs(v.y)
            # left or right
            if v.x < 0
              console.log "LEFT!"
              ans = '4'
            else
              console.log "RIGHT!"
              ans = '2'
          else
            console.log "TOP!"
            ans = '1'
        else
          # bottom
          if Math.abs(v.x) > Math.abs(v.y)
            # left or right
            if v.x < 0
              console.log "LEFT!"
              ans = '4'
            else
              console.log "RIGHT!"
              ans = '2'
          else
            console.log "BOTTOM!"
            ans = '3'

        @checkAnswer(ans, @activeCard.word)

        setTimeout =>
          @removeCard(@cardsLayer, @activeCard)
          newCard = @getCard
            name: 'whatever'+Math.random()
            draggable: false
            bottom: true
          @cardsLayer.add(newCard)
        , 100

        setTimeout =>
          @drawActiveCard(@cardsLayer)
        , 100



    checkAnswer: (tone, word) ->
      console.log "checkAnswer", tone, word.ans
      if tone == word.ans.charAt(0)
        @score += 1 * parseInt(Math.max(@combo / 2, 1))
        @combo += 1
        console.log "JIAYOU!!!!"
        @drawScores(@scoreLayer)
        console.log @score
      else
        @combo = 1

    drawActiveCard: (layer) ->
      #@activeCard = @getCard({draggable: true})
      #card = @activeCard
      @activeCard = @cards.pop()
      card = @activeCard
      card.setDraggable true

      console.log "ACTIVE CARD IS", card
      card.on 'dragstart', =>
        @startDrag()
      card.on 'dragend', (e) =>
        e.stopPropagation()
        if @dragInterval
          @endDrag()

      #layer.add(@)



    # nextCard: ->
    #   # pick a card and draw it to the canvas
    #   @context.clearRect(0,0,@width,@height)
    #   @chooseWord()
    #   @drawCard()
    #   @saveRestorePoint()

    # drawCard: ->
    #   @setDefaults()
    #   @drawCharacter(@word.char.charAt(0))
    #   @drawAscii(@word.ascii)
    #   @drawDefinition(@word.def)
    #   @drawWord(@word.char)

    # drawCharacter: (text) ->
    #   c = @context
    #   @setCanvasFont({fontSize: '200px'})
    #   c.fillStyle = '#000000'
    #   c.textBaseline = 'top'
    #   c.textAlign = 'center';
    #   c.fillText(text, @width / 2, 50);

    # drawAscii: (text) ->
    #   c = @context
    #   @setCanvasFont({fontSize: '40px'})
    #   c.fillStyle = '#666666'
    #   c.textBaseline = 'bottom'
    #   c.textAlign = 'center';
    #   c.fillText(text, @width / 2, @height - 10);

    # drawDefinition: (text) ->
    #   c = @context
    #   @setCanvasFont({fontSize: '20px'})
    #   c.fillStyle = '#888888'
    #   c.textBaseline = 'top'
    #   c.textAlign = 'left';
    #   text = text[0..20]
    #   c.fillText(text, 20, 20, @width / 2 - 20);

    # drawWord: (text) ->
    #   c = @context
    #   @setCanvasFont({fontSize: '20px'})
    #   c.fillStyle = '#888888'
    #   c.textBaseline = 'top'
    #   c.textAlign = 'right';
    #   dimensions = c.measureText(text)
    #   c.fillText(text, @width - dimensions.width, 20, @width / 2)