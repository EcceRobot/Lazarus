void update(int x, int y) {
  if ( overRect(rectX1, rectY1, rectSize, rectSize) ) {
    rect1Over = true;
  } else if ( overRect(rectX2, rectY2, rectSize, rectSize) ) {
    rect2Over = true;
  } else if ( overRect(rectX3, rectY3, rectSize, rectSize) ) {
    rect3Over = true;
  } else if ( overRect(rectX4, rectY4, rectSize, rectSize) ) {
    rect4Over = true;
  } else if ( overRect(rectX5, rectY5, rectSize, rectSize) ) {
    rect5Over = true; 
  } else {
    rect1Over = rect2Over = rect3Over = rect4Over = rect5Over = false;
  }
}
