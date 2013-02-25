import 'dart:html';
import 'dart:async';
import 'dart:math';

/**
 * Code from D. Geary example 4.13.
 * Feb 14 2013
 */

CanvasElement canvas;
CanvasRenderingContext2D ctx;
ImageElement image;

/**
 * CORS problem. I cannot make negative.
 * See:
 *  1. https://groups.google.com/a/dartlang.org/forum/?fromgroups=#!topic/misc/6TorDiBb1dE%5B1-25-false%5D
 *  2. http://blog.sethladd.com/2012/03/jsonp-with-dart.html ' Using JSONP with DART'.
 */
void main() {

  canvas = query("#canvas") as CanvasElement;
  ctx = canvas.context2d;
  ctx.font = '15px Arial';
  
  image = new ImageElement();
  image.src = './resource/curved-road.png';
//  image.src = 'http://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=900x500&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Ccolor:red%7Clabel:C%7C40.718217,-73.998284&sensor=false';
  image.onLoad.listen((e) {
    window.requestAnimationFrame(run);
  });
  
  Element button = query('#negativeButton');
  button.onClick.listen(makeNegative);
 }

  /**
   * Make the image negative by flipping the contents of image data.
   * 
   */
void makeNegative(MouseEvent e) {
  print('bouton clicked by thanh');
  
  ImageData imagedata = ctx.getImageData(0, 0, canvas.width, canvas.height);
  
  List<int> data = imagedata.data;

  //ImageData newdata = ctx.createImageData(imagedata);
  for (int i = 0; i < data.length - 4; i += 4) {
    data[i] = 255 - data[i];
    data[i + 1] = 255 - data[i + 1];
    data[i + 2] = 255 - data[i + 2];
  }

  ctx.putImageData(imagedata, 0, 0);
}

void run(num time) {
   render();
}

// Draws the image
void render(){
  ctx.drawImage(image, 0,0);
                
}
