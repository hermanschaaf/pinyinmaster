define [
    'jquery'
    'kinetic'
    'async'
    'tools'
], ($, K, async, tools) ->

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

    self = @

    constructor: (@game, @layer, level) ->
      self = @
      baseLayer = @layer
      @stage = @game.stage

      @grayText = '#454545'
      @blackText = '#000000'

      console.log "stage is", @stage

      @playing = true
      @score = 1
      @combo = 1

      @moving = false
      @mousePos = []

      @w = @stage.getWidth()
      @h = @stage.getHeight()

      @scoreLayer = new K.Layer()
      @drawScores(@scoreLayer)
      @drawTones(@scoreLayer)

      @cardsLayer = new K.Layer()
      @cardsLayer.add(new K.Rect
        x: 0
        y: 0
        width: @w
        height: @h
      )
      @drawCards(@cardsLayer)

      #@activeLayer = new K.Layer()
      @drawActiveCard(@cardsLayer)

      @stage.add(@scoreLayer)
      @stage.add(@cardsLayer)
      #@stage.add(@activeLayer)

      @startListeners()

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

    getCard: ({name, draggable, word}) ->
      draggable ?= false
      word ?= words[parseInt(Math.floor(Math.random() * words.length))]

      console.log word, draggable

      card = new K.Group(
        draggable: draggable
        name: 'group'+name
      ) 

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
      card.getX = => (left * @w)
      card.getY = => (top * @h)
      card.getWidth = => width * @w
      card.getHeight = => width * @w
      card.setSize(paper.getSize())

      return card

    drawCards: (layer) ->
      console.log "now stage is", @stage
      @cards = []
      for i in [0..1]
        card = @getCard({name: 'card'+i})
        @cards.push(card)
        layer.add(card)
        card.setZIndex(-@cards.length)

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
              ans = '1'
            else
              console.log "RIGHT!"
              ans = '3'
          else
            console.log "TOP!"
            ans = '2'
        else
          # bottom
          if Math.abs(v.x) > Math.abs(v.y)
            # left or right
            if v.x < 0
              console.log "LEFT!"
              ans = '1'
            else
              console.log "RIGHT!"
              ans = '3'
          else
            console.log "BOTTOM!"
            ans = '4'

        @checkAnswer(ans, @activeCard.word)

        setTimeout =>
          @removeCard(@cardsLayer, @activeCard)
          newCard = @getCard
            name: 'whatever'+Math.random()
            draggable: false
          @cardsLayer.add(newCard)
          @cards.push(newCard)
          newCard.setZIndex(-@cards.length)
          @bottomStack -= 1
          
        , 100

        setTimeout =>
          @drawActiveCard(@cardsLayer)
        , 100



    checkAnswer: (tone, word) ->
      console.log "checkAnswer", tone, word.ans
      if tone == word.ans.charAt(0)
        @score += 1 * parseInt(Math.max(@combo / 2, 1))
        @combo += 1
        @drawScores(@scoreLayer)
        @drawGlow(word.ans.charAt(0), true)
        console.log @score
      else
        @combo = 1
        @drawGlow(tone, false)

    drawGlow: (tone, correct) ->
      glow = false
      if tone == '4'
        glow = new K.Rect
          x: 0
          y: 0
          width: @w
          height: 10
          fill: if correct then "#00ff00" else "#ff0000"
          stroke: 'none'
      if tone == '3'
        glow = new K.Rect
          x: @w-10
          y: 0
          width: 10
          height: @h
          fill: if correct then "#00ff00" else "#ff0000"
          stroke: 'none'
      if tone == '4'
        glow = new K.Rect
          x: 0
          y: @h - 10
          width: @w
          height: 10
          fill: if correct then "#00ff00" else "#ff0000"
          stroke: 'none'
      if tone == '1'
        glow = new K.Rect
          x: 0
          y: 0
          width: 10
          height: @h
          fill: if correct then "#00ff00" else "#ff0000"
          stroke: 'none'
      if glow
        @scoreLayer.clear()
        @scoreLayer.add(glow)
        @scoreLayer.draw()
        console.log "GLOW IS", glow

    drawActiveCard: (layer) ->
      #@activeCard = @getCard({draggable: true})
      #card = @activeCard
      @activeCard = @cards.shift()
      card = @activeCard
      #card.setDraggable true

      #console.log "ACTIVE CARD IS", card
      # card.on 'dragstart', =>
      #   @startDrag()
      # card.on 'dragend', (e) =>
      #   e.stopPropagation()
      #   if @dragInterval
      #     @endDrag()

      #layer.add(@)

    clip: (shape, mask, callback) ->
      
      # Asynchronous function to clip an object 
      cb = (img) ->
        mask.setFillPatternImage img
        console.log "CLIPPING MF"
        console.log mask.getOffset(), shape.getOffset(), shape.getX(), shape.getY(), shape.x, shape.y
        mask.setX shape.getX() + mask.getOffset().x
        mask.setY shape.getY() + mask.getOffset().y
        mask.setFillPatternOffset
          x: mask.getOffset().x + shape.getX() # we set x and y specifically when we create the card
          y: mask.getOffset().y + shape.getY()

        mask.setFillPatternRepeat "no-repeat"
        console.log "calling callback!"
        callback null, mask

      console.log shape.toImage(callback: cb)

    flick: (shape, direction, sideWays) ->
      dir = (if direction is "top" then -1 else 1)
      if sideWays
        sideWays = (if sideWays is "left" then -1 else 1)
      else
        sideWays = 0
      console.log "width is", shape.getWidth(), shape.getHeight()
      shape.transitionTo
        x: shape.getX() + 100 + Math.random() * 100 + sideWays * Math.random() * 1000
        y: (if (direction is "top") then -500 - Math.max(shape.getWidth(), shape.getHeight()) * 1.41 else self.h + 100)
        rotation: Math.random() * 2
        duration: 1


    startListeners: ->
      console?.log "adding listeners"

      @moving = false
      @mousePos = []
      stage = @stage
      layer = @cardsLayer

      stage.on "mousedown", (e) ->
        console.log "mousedown @@@"
        if self.moving
          self.moving = false
        else
          self.mousePos = []
          self.moving = true

      #layer.drawScene();
      stage.on "mousemove", (e) ->
        if self.moving
          self.mousePos.push stage.getMousePosition()
          self.moving = true


      #layer.drawScene();
      stage.on "mouseup", ->
        console.log "mouseup @@@"
        activeCard = self.activeCard
        mousePos = self.mousePos
        moving = self.moving
        layer = self.cardsLayer

        console.log "moving", moving

        if moving
          moving = false
          
          console.log self, self.activeCard
          # y = m (x-x1)+ y1
          origin = # origin
            x: self.activeCard.getX()
            y: self.activeCard.getY()

          p1 = mousePos[0] # first position of mouse drag
          p2 = mousePos[mousePos.length - 1] # end mouse position
          constY = (p1.y - origin.y)
          corner = self.getCorner(mousePos)
          if corner # third tone
            console.log "third!"
            m1 = (corner.y - p1.y) / (corner.x - p1.x) # gradient1
            m2 = (p2.y - corner.y) / (p2.x - corner.x) # gradient2
            corner1 = # point through (-200, y)
              x: -200
              y: m1 * (-200 - (corner.x - origin.x)) + constY

            corner2 = # point through (400, y)
              x: 400
              y: m2 * (400 - (corner.x - origin.x)) + constY

            mask1 = new K.Polygon(points: [corner1.x, corner1.y, corner.x, corner.y, corner2.x, corner2.y])
            
            #stroke: 'red',
            #strokeWidth: 4
            mask2 = new K.Polygon(
              points: [corner.x, corner.y, corner1.x, corner1.y, corner1.x, corner1.y + 500, corner.x, corner.y + 500]
              x: 0
              y: 0
            )
            
            #stroke: 'red',
            #strokeWidth: 4
            mask3 = new K.Polygon(
              points: [corner.x, corner.y, corner2.x, corner2.y, corner2.x, corner2.y + 500, corner.x, corner.y + 500]
              x: 0
              y: 0
            )
            
            #stroke: 'red',
            #strokeWidth: 4
            console.log mask1
            layer.add mask1
            layer.add mask2
            layer.add mask3
            
            #layer.drawScene();
            async.parallel
              clip1: (done) =>
                console.log "clip1.."
                self.clip self.activeCard, mask1, done

              clip2: (done) =>
                self.clip self.activeCard, mask2, done

              clip3: (done) =>
                self.clip self.activeCard, mask3, done
            , (err, results) ->
              console.log "clips", results
              clip1 = results.clip1
              clip2 = results.clip2
              clip3 = results.clip3
              self.flick clip1, "top"
              self.flick clip2, "bottom", "left"
              self.flick clip3, "bottom", "right"
              self.activeCard.remove()
              layer.drawScene()

          else
            m = (p2.y - p1.y) / (p2.x - p1.x) # gradient
            if m >= 0.3
              console.log "fourth!"
            else if m <= -0.3
              console.log "second!"
            else
              console.log "first!"

            card = 
              width: self.activeCard.getWidth()
              height: self.activeCard.getHeight()
            
            #var c = m ;// constant
            corner1 =
              x: 0
              y: m * (0 - (p1.x - origin.x)) + constY

            corner2 =
              x: 0 + card.width # + width
              y: m * (card.width - (p1.x - origin.x)) + constY

            mask1 = new K.Polygon(
              points: [corner1.x, corner1.y, 0, 0, card.width, 0, corner2.x, corner2.y]
              x: 0
              y: 0
              stroke: 'red'
              strokeWidth: 5
            )
            mask2 = new K.Polygon(
              points: [corner1.x, corner1.y, 0, card.height, card.width, card.height, corner2.x, corner2.y]
              x: 0
              y: 0
              stroke: 'red'
              strokeWidth: 5
            )
            layer.add mask1
            layer.add mask2
            async.parallel
              clip1: (done) =>
                self.clip self.activeCard, mask1, done

              clip2: (done) =>
                self.clip self.activeCard, mask2, done
            , (err, results) ->
              console.log "clips", results
              clip1 = results.clip1
              clip2 = results.clip2
              self.flick clip1, "top"
              self.flick clip2, "bottom"
              self.activeCard.remove()
              layer.drawScene()

        moving = false

    getCorner: (points) ->
      layer = self.cardsLayer
      ms = []
      corners = []
      startPoint = points[0]
      endPoint = points[points.length - 1]
      
      # get the gradient between every two points
      i = 3

      while i < points.length - 3
        xdif = (points[i + 1].x - points[i].x)
        ms.push (points[i + 1].y - points[i].y) / ((if xdif is 0 then 0.000001 else xdif))
        console.log ms[ms.length - 1], ms[ms.length - 2]
        if i > 0 and i < points.length - 1
          lastGradient = ms[ms.length - 1]
          prevGradient = ms[ms.length - 1]
          point = new Kinetic.Circle(
            x: points[i].x
            y: points[i].y
            radius: 5
            stroke: (if lastGradient >= 0 then "blue" else "green")
            strokeWidth: 1
          )
          layer.add point
          layer.drawScene()
          corners.push i  if lastGradient <= 0.3 and prevGradient >= -0.3
        i++
      
      # take the corner closest to the middle of all the points \:D/
      mid = points.length / 2
      closest = 0
      i = 0
      while i < corners.length
        closest = i  if Math.abs(corners[closest] - mid) > Math.abs(corners[i] - mid)
        i++
      if corners.length > 0
        corner = points[corners[closest]]
        xdif1 = (corner.x - points[0].x)
        m1 = (corner.y - points[0].y) / ((if xdif1 is 0 then 0.000001 else xdif1))
        xdif2 = (corner.x - points[points.length - 1].x)
        m2 = (corner.y - points[points.length - 1].y) / ((if xdif2 is 0 then 0.000001 else xdif2))
        if m1 >= 0.3 and m2 <= -0.3
          point = new Kinetic.Circle(
            x: points[corners[closest]].x
            y: points[corners[closest]].y
            radius: 10
            stroke: "red"
            strokeWidth: 5
          )
          layer.add point
          return corner
      false


    selectTone: ->
      difX = mousePos2.x - mousePos1.x
      difY = mousePos2.y - mousePos1.y

      if Math.abs(mousePosMax.difY) <= Math.abs(difY) + 10
        if difY > 50 and difX > 50
          console.log "fourth!"
          return '4'
        if difY < -50 and difX > 50
          console.log "second!"
          return '2'
      if difX > 50 or difX < -50
        if mousePosMax.difY > 20 and mousePosMax.y - mousePos2.y > 20
          console.log "third!"
          return '3'
        else
          console.log "first!"
          return '1'
      return '5'

    #clip: ->
      # check out http://jsfiddle.net/8gvG4/
      # also see http://jsfiddle.net/y2XaD/1/
      # and http://jsfiddle.net/9GqhS/
      # and... http://jsfiddle.net/NAfZa/3/



