
# util function:
fixPosition = (e, gCanvasElement) ->
  x = undefined
  y = undefined
  if e.pageX or e.pageY
    x = e.pageX
    y = e.pageY
  else
    x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
    y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
  x -= gCanvasElement.offsetLeft
  y -= gCanvasElement.offsetTop
  x: x
  y: y

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

mousePos1 = {}
mousePosMax = {}
mousePos2 = {}
down = false
score = 0

$el = $('#game')
canvas = document.getElementById('game');

$('.startgame').click (e) ->
  new Game(document.getElementById('game'))
  return false

class Game
  
  constructor: (@canvas) ->
    console.log @canvas
    @context = @canvas.getContext('2d')
    @restorePoint = false;

    @width = @canvas.width
    @height = @canvas.height

    @jiayous = []

    @setDefaults()
    @nextCard()
    setInterval => 
      @redraw(this)
    , 100
    
    @$score = $('.score')

    @playing = false
    @score = 1
    @combo = 1
    @startListeners()
    @startGame()

  setDefaults: ->
    @defaults = 
      fontFamily: 'Georgia, "Times New Roman", "Microsoft YaHei", "微软雅黑", STXihei, "华文细黑", serif'
      fontSize: '40px'
      fontStyle: 'normal'
      fillStyle: '#000000'
    @setCanvasFont(@defaults)
    @canvas.fillStyle = @defaults.fillStyle

  setCanvasFont: ({fontStyle,  fontSize, fontFamily}) ->
    obj = @defaults
    if fontStyle then obj.fontStyle = fontStyle
    if fontSize then obj.fontSize = fontSize
    if fontFamily then obj.fontFamily = fontFamily
    @context.font = obj.fontStyle + ' ' + obj.fontSize + ' ' + obj.fontFamily;

  nextCard: ->
    # pick a card and draw it to the canvas
    @context.clearRect(0,0,@width,@height)
    @chooseWord()
    @drawCard()
    @saveRestorePoint()

  drawCard: ->
    @setDefaults()
    @drawCharacter(@word.char.charAt(0))
    @drawAscii(@word.ascii)
    @drawDefinition(@word.def)
    @drawWord(@word.char)

  drawCharacter: (text) ->
    c = @context
    @setCanvasFont({fontSize: '200px'})
    c.fillStyle = '#000000'
    c.textBaseline = 'top'
    c.textAlign = 'center';
    c.fillText(text, @width / 2, 50);

  drawAscii: (text) ->
    c = @context
    @setCanvasFont({fontSize: '40px'})
    c.fillStyle = '#666666'
    c.textBaseline = 'bottom'
    c.textAlign = 'center';
    c.fillText(text, @width / 2, @height - 10);

  drawDefinition: (text) ->
    c = @context
    @setCanvasFont({fontSize: '20px'})
    c.fillStyle = '#888888'
    c.textBaseline = 'top'
    c.textAlign = 'left';
    text = text[0..20]
    c.fillText(text, 20, 20, @width / 2 - 20);

  drawWord: (text) ->
    c = @context
    @setCanvasFont({fontSize: '20px'})
    c.fillStyle = '#888888'
    c.textBaseline = 'top'
    c.textAlign = 'right';
    dimensions = c.measureText(text)
    c.fillText(text, @width - dimensions.width, 20, @width / 2)

  saveRestorePoint: ->
    @restorePoint = @canvas.toDataURL()
    console.log "saved!!"

  loadRestorePoint: ->
    if @restorePoint
      img = new Image()
      img.src = @restorePoint
      @context.clearRect(0, 0, @width, @height);
      @context.drawImage(img, 0, 0)
      console.log "restored!"

  startListeners: ->
    $(document).mousemove (e) =>
      if down
        page = fixPosition(e, @canvas)
        if Math.abs(mousePosMax.difY) < Math.abs(page.y - mousePos1.y)
          mousePosMax.difY = page.y - mousePos1.y
          mousePosMax.y = page.y
        @context.strokeStyle = '#ffff00';
        @context.lineWidth = 10;
        pos = fixPosition(e, @canvas);
        @context.lineTo(pos.x, pos.y);
        @context.stroke();

    $el.mousedown (e) =>
      down = (true and @playing)
      @context.beginPath()
      mousePos1 = fixPosition(e, @canvas)
      mousePosMax = 
        difY: 0
        y: 0

    $(document).mouseup (e) =>
      if down and @playing
        down = false
        @loadRestorePoint()
        mousePos2 = fixPosition(e, @canvas)
        tone = @selectTone()
        console.log tone
        @checkAnswer(tone)
        @nextCard()
        #@saveRestorePoint()

  startGame: -> 
    console.log 'start!'
    @playing = true
    $el.find('.startgame').addClass('hidden').end().find('.game').removeClass('hidden')
    @nextCard()

  checkAnswer: (tone) ->
    console.log tone, @word.ans, @combo
    if tone == @word.ans
      @score += 1 * parseInt(Math.max(@combo / 2, 1))
      @combo += 1
      @$score.text(@score)
      @showJiayou()
      console.log "JIAYOU!!!!"
      @saveRestorePoint()
    else
      @combo = 1

  showJiayou: ->
    console.log "nice!!"

    c = @context
    @jiayous.push
      'fontSize': 30
      'text': 'nice!'
      'left': @width - (50 * Math.random()) - 50
      'top': @height - (50 * Math.random()) - 20
      'step': 0

    console.log 'nice', @jiayous


  
  redraw: (self) ->

    console.log 'jiayous is', self.jiayous
    if @jiayous?.length
      c = @context
      c.clearRect(0,0,@width,@height)
      @drawCard()
      c.fillStyle = '#ff0000'
      c.textBaseline = 'top'
      c.textAlign = 'center';
      console.log "length is", self.jiayous.length
      toRemove = []
      for i in [0..self.jiayous.length]
        jiayou = self.jiayous[i]
        if jiayou
          @setCanvasFont({fontSize: (jiayou.fontSize + jiayou.step) + 'px'})
          self.jiayous[i].step += 1
          console.log ('step')
          if self.jiayous[i].step > 10
            toRemove.push i

          c.fillText('nice!', jiayou.left, jiayou.top)
          console.log(jiayou.left, jiayou.top)

      console.log "to remove", toRemove
      for i in [0..toRemove.length]
        console.log "removing!", i, self.jiayous
        r = toRemove[i]-i
        self.jiayous?.splice(r, 1) 
        console.log 'now', self.jiayous

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

  chooseWord: ->
    @word = words[parseInt(Math.random() * words.length)]
    return @word
