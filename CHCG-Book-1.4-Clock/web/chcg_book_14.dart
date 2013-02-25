import 'dart:html';
import 'dart:async';
import 'dart:math';

/**
 * Code from D. Geary example 1.4.
 * Feb 13 2013
 */
const Duration TIMEOUT =  const Duration(seconds: 1);

CanvasElement canvas;
CanvasRenderingContext2D ctx;

const int FONT_HEIGHT = 15;
const int MARGIN = 35;
const int NUMERAL_SPACING = 20;
num HAND_TRUNCATION = canvas.width/25;
num HOUR_HAND_TRUNCATION = canvas.width/10;
num RADIUS = canvas.width/2 - MARGIN;
num HAND_RADIUS = RADIUS + NUMERAL_SPACING;



void main() {

  canvas = query("#canvas") as CanvasElement;
  ctx = canvas.context2d;
  ctx.font = '15px Arial';

  HAND_TRUNCATION = canvas.width/25;
  HOUR_HAND_TRUNCATION = canvas.width/10;
  RADIUS = canvas.width/2 - MARGIN;
  HAND_RADIUS = RADIUS + NUMERAL_SPACING;
  createTimer();
 }

Timer createTimer() {
  return new Timer.repeating(TIMEOUT.inMilliseconds, drawClock);
  
}
  void drawClock(Timer timer) {
    ctx.clearRect(0,0,canvas.width,canvas.height);

    drawCircle();
    drawCenter();
    drawHands();
    drawNumerals();
  }
  
  
  /**
   * 
   */
  void drawCircle() {
    ctx.beginPath();
    ctx.arc(canvas.width/2, canvas.height/2,
        RADIUS, 0, PI*2, true);
    ctx.stroke();
  }
  
  void drawCenter() {
    ctx.beginPath();
    ctx.arc(canvas.width/2, canvas.height/2, 5, 0, PI*2, true);
    ctx.fill();
  }
  
  /**
   * 
   */
  void  drawHand(loc, isHour) {
    var angle = (PI*2) * (loc/60) - PI/2,
        handRadius = isHour ? RADIUS - HAND_TRUNCATION-HOUR_HAND_TRUNCATION 
            : RADIUS - HAND_TRUNCATION;

    ctx.moveTo(canvas.width/2, canvas.height/2);
    ctx.lineTo(canvas.width/2  + cos(angle)*handRadius, 
        canvas.height/2 + sin(angle)*handRadius);
    ctx.stroke();
  }

  void drawHands() {
    DateTime date = new DateTime.now();
    int hour = date.hour;
    hour = hour > 12 ? hour - 12 : hour;
    drawHand(hour*5 + (date.minute/60)*5, true);
    drawHand(date.minute, false);
    drawHand(date.second, false);
  }

  void drawNumerals() {
    var numerals = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ];
    num angle = 0;
    num numeralWidth = 0;

    numerals.forEach((numeral) {
      angle = PI/6 * (numeral-3);
      TextMetrics metrics = ctx.measureText(numeral.toString());
      ctx.fillText(numeral.toString(), 
         canvas.width/2  + cos(angle)*(HAND_RADIUS) - metrics.width/2,
         canvas.height/2 + sin(angle)*(HAND_RADIUS) + FONT_HEIGHT/3);
   });
}



