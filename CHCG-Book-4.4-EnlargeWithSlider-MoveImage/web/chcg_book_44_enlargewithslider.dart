import 'dart:html';
import 'dart:async';
import 'dart:math';
//import 'package:MyFirstLibrary'

/**
 * Code from D. Geary example 4.4.
 * Feb 18 2013
 */

CanvasElement canvas;
CanvasRenderingContext2D ctx;
ImageElement image;
RangeInputElement sliderElement;
Element scaleOutput;
//num scale;
const num MINIMUM_SCALE = 0.1;
const num MAXIMUM_SCALE = 10.0;
num mouseDownAtX = 0; // to remember where i clicked the mouse
num mouseDownAtY = 0;
num lastPosX = 0; // where the image was last drawn at
num lastPosY = 0;
num scaleValue = 1.0;
num imagePosX = 0;
num imagePosY = 0;

StreamSubscription mouseMoveListener = null; // mouse move listener

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
  ctx.font = '15px Arial';
  ctx.fillStyle     = "dashed";
  ctx.strokeStyle   = 'yellow';
  ctx.shadowColor   = 'rgba(50, 50, 50, 1.0)';
  ctx.shadowOffsetX = 5;
  ctx.shadowOffsetY = 5;
  ctx.shadowBlur    = 10;
  
  //canvas.style.border = 'none'; this works but i want to make border visible
  
  canvas.onMouseDown.listen((MouseEvent e) {
    mouseMoveListener = canvas.onMouseMove.listen(mouseMoveHandler);
    mouseDownAtX = e.clientX;
    mouseDownAtY = e.clientY;
 });
  
  
  //canvas.onMouseOut.listen(onMouseUpOrOut);
  canvas.onMouseUp.listen(onMouseUpOrOut);
  
  /**
   * Reset button
   */
  InputElement resetButt = query("#resetButton");
  resetButt.onClick.listen(onReset);
  
  /**
   * Slider stuff
   */
  sliderElement = query('#scaleSlider');
  scaleOutput = query('#scaleOutput');
  sliderElement.onChange.listen(sliderOnChange);

  /**
   * Show image
   */
  image = new ImageElement();
  //image.src = './resource/waterfall.png';
  image.src = 'http://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=900x500&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Ccolor:red%7Clabel:C%7C40.718217,-73.998284&sensor=false';
  image.onLoad.listen((e) {
    window.requestAnimationFrame(run);
  });
}

void run(num time) {
   render();
}

/**
 * Reset handler.
 */
void onReset(Event e) {
  sliderElement.value = "1.0";
  scaleValue = 1.0;
  scaleOutput.innerHtml = "<div>$scaleValue</div>";
  lastPosX = 0;
  lastPosY = 0;
  imagePosX = 0;
  imagePosY = 0;
  doDrawImage();
}

// Draws the image
void render(){
  
  // Set the canvas size to equal image size
  int marginX = 20;
  
  print('canvas: ${canvas.width} vs ${canvas.clientWidth} -- image: ${image.width}');
  double ratio = image.width / image.height;
  canvas.width = image.width + marginX;
  canvas.height = image.height + (marginX / ratio).toInt();

  ctx.drawImage(image, 0, 0);   
}

void onMouseUpOrOut(MouseEvent e) {
    /**
     * process 'mouseout' only if there is a moveListener
     */
    if (e.type != 'mouseout' && mouseMoveListener != null) {
      lastPosX += e.clientX - mouseDownAtX;
      lastPosY += e.clientY - mouseDownAtY;
      print('onMouseUpOrOut: ${e.type}  imagePos:[$imagePosX, $imagePosY] lastPos:[$lastPosX, $lastPosY]');
    }

    if (mouseMoveListener != null) {
      mouseMoveListener.cancel();  
      mouseMoveListener = null;
    }


}

void mouseMoveHandler(MouseEvent e) {
  imagePosX = e.clientX - mouseDownAtX + lastPosX;
  imagePosY = e.clientY - mouseDownAtY + lastPosY;
  
  doDrawImage();
}


/**
 * Slider handler. Its responsibility is to change scaleValue.
 */
void sliderOnChange(Event e) { 
   scaleValue = sliderElement.valueAsNumber;
   //num percent = (scaleValue - MINIMUM_SCALE) / (MAXIMUM_SCALE - MINIMUM_SCALE);
   //percent = percent < 0.35 ? 0.35 : percent;

   /**
    * Draw scale value
    */
   scaleOutput.innerHtml = "<div>$scaleValue</div>";
   //String fontsize = '${percent*MAXIMUM_SCALE/1.5} em';
   //scaleOutput.style.fontSize = fontsize;
   
   //print('scaleValue = $scaleValue');

   //print('sliderOnChange:   imagePos:[$imagePosX, $imagePosY] lastPos:[$lastPosX, $lastPosY]');
   
   doDrawImage();
}

void doDrawImage() {
  /**
    * Draw scaled image
    */
   var w = canvas.width,
       h = canvas.height;
   
   var sw = w * scaleValue;
   var sh = h * scaleValue;
   ctx.clearRect(0,0, w, h);
   ctx.drawImage(image, imagePosX, imagePosY, sw, sh);
   
   //print('imagePos:[$imagePosX, $imagePosY]');
   
   drawFrame();
   
}

void drawFrame() {
  var w = canvas.width,
      h = canvas.height;
  var sw = w * scaleValue;
  var sh = h * scaleValue;
  //ctx.fillStyle = '#f00';
  
  /*
  ctx.moveTo(imagePosX - sw/2, imagePosY - sh/2);
  ctx.lineTo(imagePosX - sw/2, imagePosY - sh/2);
  ctx.lineTo(50, 100);
  ctx.lineTo(0, 90);
  ctx.closePath();
  */
  ctx.beginPath();
  ctx.strokeRect(imagePosX , imagePosY, sw, sh, 1);
  ctx.stroke();
}

