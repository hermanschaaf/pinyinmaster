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

      console.log "stage is", @stage

      @w = @stage.getWidth()
      @h = @stage.getHeight()

      @scoreLayer = new K.Layer()
      @drawScores(@scoreLayer)

      @cardsLayer = new K.Layer()
      @drawCards(@cardsLayer)

      #@activeLayer = new K.Layer()
      @drawActiveCard(@cardsLayer)

      @stage.add(@scoreLayer)
      @stage.add(@cardsLayer)
      #@stage.add(@activeLayer)

    drawScores: (layer) ->
      score = new K.Text
        x: @w * 0.05
        y: @h * 0.05
        text: '1,000'
        fontSize: @h * 0.1
        fontFamily: 'karatemedium'
        fill: 'white'
        align: 'left'
        width: @w * 0.5
        padding: 5
      layer.add(score)

    getCard: ({name, draggable, word}) ->
      draggable ?= false
      word ?= words[parseInt(Math.floor(Math.random() * words.length))]

      console.log word, draggable

      card = new K.Group(
        draggable: draggable
      ) 

      randX = Math.random()
      randY = Math.random()

      paper = tools.createRect
        stage: @stage
        top: 0.2 + randY * 0.05
        left: 0.5 + randX * 0.05
        width: 0.8
        marginLeft: -0.5
        marginTop: 0.0
        height: 'square'
        name: name
        fill: '#f2f2ea'
        stroke: 'none'
        strokeWidth: 0
      tools.addShadow(paper)

      char = new K.Text
        y: (0.2 + randY * 0.05) * @w
        x: (0.5 + randX * 0.05) * @w - (0.3 * @w)
        text: word.char
        fontSize: 0.6 * @w
        fontFamily: 'arial'
        fill: 'black'
        align: 'center'
        width: 0.6 * @w
        padding: @w * 0.1

      card.add(paper)
      card.add(char)
      card.setSize(paper.getSize())

      return card

    drawCards: (layer) ->
      console.log "now stage is", @stage
      @cards = []
      for i in [0..5]
        card = @getCard({name: 'card'+i})
        @cards.push(card)

        layer.add(card)

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
      , 30

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

      if Math.abs(xVel) > 0.05
        console.log "flick off X, motherflicker!"
        overThresholdX = 1
        
      if Math.abs(yVel) > 0.05
        console.log "flick off Y, motherflicker!"
        overThresholdY = 1 

      console.log 'xvel', xVel, overThresholdX, overThresholdY

      if overThresholdY or overThresholdX
        # anim = new K.Animation( {
        #   func: (frame) =>
        #     #console.log xVel
        #     console.log 'frametime', frame.time
        #     xVel = (xVel + (xVel * xFriction)) * overThresholdX
        #     yVel = (yVel + (yVel * yFriction)) * overThresholdY
        #     console.log 'xvel', xVel, 'yvel', yVel
        #     @activeCard.setX(@activeCard.getX() + xVel * @w * 0.01 )
        #     @activeCard.setY(@activeCard.getY() + yVel * @h * 0.01)
        # ,
        # node: @activeLayer
        # )

        # anim.start();

        @activeCard.transitionTo
          x: @activeCard.getX() + (xVel / Math.abs(xVel) * @w) * overThresholdX
          y: @activeCard.getY() + (yVel / Math.abs(yVel) * @h) * overThresholdY
          duration: 0.2
          easing: 'ease-out'

        setTimeout =>
          @drawActiveCard(@cardsLayer)
        , 0.1

        # @animStopInterval = undefined
        # @animStopInterval = setInterval ((card, interval, w, h, game) ->
        #   return =>
        #     console.log card.getX(), card.getY(), card.getWidth(), card.getHeight(), card.getSize()
        #     stop = false
        #     if card.getX() + card.getWidth() < 0
        #       console.log "x over left"
        #       stop = true
        #     else if card.getX() > w
        #       stop = true
        #       console.log "x over right"
        #     else if card.getY() > h
        #       stop = true
        #       console.log "y over bottom"
        #     else if card.getY() + card.getHeight() < 0
        #       stop = true
        #       console.log "y over top"

        #     if stop
        #       console.log "STOPPING!", interval, game
        #       anim.stop()
        #       clearInterval(game.animStopInterval)
        #       game.drawActiveCard(game.cardsLayer)

        #   )(@activeCard, @animStopInterval, @w, @h, @)
        # , 30


    drawActiveCard: (layer) ->
      #@activeCard = @getCard({draggable: true})
      #card = @activeCard
      @activeCard = @cards.pop()
      card = @activeCard
      card.setDraggable true

      console.log "ACTIVE CARD IS", card
      card.on 'dragstart', =>
        @startDrag()
      card.on 'dragend', =>
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