import 'dart:html';
import 'dart:async';
import 'dart:math';

/**
 * Code from D. Geary example 4.4.
 * Feb 18 2013
 */

CanvasElement canvas;
CanvasRenderingContext2D ctx;
ImageElement image;
RangeInputElement scaleSlider;
Element scaleOutput;
num scale;
const num MINIMUM_SCALE = 0.1;
const num MAXIMUM_SCALE = 10.0;
num mouseDownAtX; // to remember where i clicked the mouse
num mouseDownAtY;
num lastPosX = 0; // where the image was last drawn at
num lastPosY = 0;

var mouseListener; // mouse move listener

/**
 * CORS problem. I cannot make negative.
 * See:
 *  1. https://groups.google.com/a/dartlang.org/forum/?fromgroups=#!topic/misc/6TorDiBb1dE%5B1-25-false%5D
 *  2. http://blog.sethladd.com/2012/03/jsonp-with-dart.html ' Using JSONP with DART'.
 */
void main() {

  /**
   * Canvas stuff
   */
  canvas = query("#canvas");
  ctx = canvas.context2d;
  //ctx.font = '15px Arial';
  ctx.fillStyle     = "cornflowerblue";
  ctx.strokeStyle   = 'yellow';
  ctx.shadowColor   = 'rgba(50, 50, 50, 1.0)';
  ctx.shadowOffsetX = 5;
  ctx.shadowOffsetY = 5;
  ctx.shadowBlur    = 10;
  
  /**
   * On mouse down, set the position the mouse was clicked
   * (for use in the image drawing funciton)
   */
  canvas.onMouseDown.listen((MouseEvent e) {
    mouseListener = canvas.onMouseMove.listen(mouseMoveHandler);
    mouseDownAtX = e.clientX;
    mouseDownAtY = e.clientY;
 });
  
  /**
   * On mouse up, remember the last position
   */
  canvas.onMouseUp.listen((MouseEvent e) {
    mouseListener.cancel();
    
    lastPosX += e.clientX - mouseDownAtX;
    lastPosY += e.clientY - mouseDownAtY;
    print('last pos at $lastPosX;$lastPosY');
 });
  
  /**
   * Slider stuff
   */
  scaleSlider = query('#scaleSlider');
  scaleOutput = query('#scaleOutput');
  scale = MINIMUM_SCALE;
  scaleSlider.onChange.listen(sliderOnChange);

  /**
   * Show image
   */
  image = new ImageElement();
  image.src = './resource/waterfall.png';
  image.src = 'http://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=900x500&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Ccolor:red%7Clabel:C%7C40.718217,-73.998284&sensor=false';
  image.onLoad.listen((e) {
    window.requestAnimationFrame(run);
  });
}

void run(num time) {
   render();
}

// Draws the image
void render(){
  ctx.drawImage(image, 0,0);              
}


void mouseMoveHandler(MouseEvent e) {
  var x = e.clientX - mouseDownAtX + lastPosX;
  var y = e.clientY - mouseDownAtY + lastPosY;
  
  
  
  ctx.clearRect(0,0,canvas.width,canvas.height);
  ctx.drawImage(image, x, y);
  
  print('drawing at $x;$y (FYI: ${e.clientX} vs ${e.x} - ${e.clientY} vs ${e.y})');
 }


/**
 * 
 */
void sliderOnChange(Event e) { 
   var value = scaleSlider.valueAsNumber;
   num percent = (value - MINIMUM_SCALE) / (MAXIMUM_SCALE - MINIMUM_SCALE);

   /**
    * Draw scale value
    */
   scaleOutput.innerHtml = "<div>$value</div>";
   percent = percent < 0.35 ? 0.35 : percent;
   String fontsize = '${percent*MAXIMUM_SCALE/1.5} em';
   scaleOutput.style.fontSize = fontsize;
   
   print('value = $value; percent = $percent - fontsize = ${fontsize}');
   
   /**
    * Draw scaled image
    */
   var w = canvas.width,
       h = canvas.height;
   
   var sw = w * scale;
   var sh = h * scale;
   ctx.clearRect(0,0,canvas.width,canvas.height);
   ctx.drawImage(image, -sw/2 + w/2, -sh/2 + h/2, sw, sh);
   
}

