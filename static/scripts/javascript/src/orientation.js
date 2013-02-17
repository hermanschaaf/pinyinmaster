define ([
    'jquery',
    'kinetic',
    'game'
], function ($, K, game) {

  var stage = game.stage
  
  var rc = 0;  // resize counter
  var oc = 0;  // orientiation counter
  var ios = navigator.userAgent.match(/(iPhone)|(iPod)/); // is iPhone
  
  function orientationChange() {
    // inc orientation counter
    oc++;
  }
  function resizeCanvas() {
    // inc resize counter
    rc++;

    if (ios) {
      // increase height to get rid off ios address bar
      $("#container").height($(window).height() + 60)
    }
    
    var width = $("#container").width();
    var height = $("#container").height();
    
    cheight = height; // subtract the fix height
    cwidth = width;
    
    // set canvas width and height
    stage.setSize(cwidth, cheight);

    // hides the WebKit url bar
    if (ios) {
      setTimeout(function() {
        window.scrollTo(0, 1);
      }, 100);   
    }
  }

  var resizeTimeout;
  $(window).resize(function() {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(resizeCanvas, 100);
  });
  resizeCanvas();
  
  var otimeout;
  window.onorientationchange = function() {
    clearTimeout(otimeout);
    otimeout = setTimeout(orientationChange, 50);
  }       

});
