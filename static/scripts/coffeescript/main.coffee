require [
    "jquery", 
    "game", 
    "orientation",
    "waitfont",
    "menus",
    "kinetic",
     
  ], ($, Game, fixOrientation) ->
    $ ->
      waitForWebfonts ['karatemedium'], ->
        console.log "fonts loaded whoop whoop"
        game = new Game('container')
        console.log "launching game..."
        game.startGame()

        fixOrientation(game)