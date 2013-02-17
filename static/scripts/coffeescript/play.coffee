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
      #@drawCards(@cardsLayer)

      @activeLayer = new K.Layer()
      @drawActiveCard(@activeLayer)

      @stage.add(@scoreLayer)
      @stage.add(@cardsLayer)
      @stage.add(@activeLayer)

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

    getCard: ({name, draggable}) ->
      draggable ?= false

      card = tools.createRect
        stage: @stage
        top: 0.2 + Math.random() * 0.05
        left: 0.5 + Math.random() * 0.05
        width: 0.8
        marginLeft: -0.5
        marginTop: 0.0
        height: 'square'
        name: name
        draggable: draggable
        fill: '#f2f2ea'
        stroke: 'none'
        strokeWidth: 0
      tools.addShadow(card)
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

      if Math.abs(xVel) > 0.2
        console.log "flick off X, motherflicker!"
        
      if Math.abs(yVel) > 0.2
        console.log "flick off Y, motherflicker!"
        

    drawActiveCard: (layer) ->
      @activeCard = @getCard({draggable: true})
      card = @activeCard

      console.log "ACTIVE CARD IS", card
      card.on 'dragstart', =>
        @startDrag()
      card.on 'dragend', =>
        @endDrag()

      layer.add(card)



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