int rectX1, rectY1, rectX2, rectY2, rectX3, rectY3, rectX4, rectY4, rectX5, rectY5;      // Position of square button
int rectSize = 89;     // Diameter of rect
boolean rect1Over = false, rect2Over = false, rect3Over = false, rect4Over = false, rect5Over = false;
String numbers = "";

void draw(){
  
  update(mouseX, mouseY);
  background(255);
  
  fill(0);
  
  //testo
  //font = createFont("SegoeScript-18",18);
  font = createFont("Travis_Lee_Street-18",18);
  textFont(font);
  
  if (rect1Over) {
  image(IMG_load, rectX1, rectY1- 45 );
  text("Choose the file that you want get back to life",1*width/4-rectSize-40, 260+height/6);
  } else if (rect2Over) {
    image(IMG_height, rectX2, rectY2-50);
    text("Insert the measure where the printing was interrupted",1*width/4-rectSize-40, 260+height/6);
    cursor(TEXT);
  } else if (rect3Over) {
    image(IMG_save, rectX3, rectY3-50);
    text("It will be saved as namefile_Lazarus.gcode",1*width/4-rectSize-40, 260+height/6);
  } else if (rect4Over) {
    image(IMG_close, rectX4, rectY3-40);
    text("Good luck",1*width/4-rectSize-40, 260+height/6);
  } else if (rect5Over) {
    image(IMG_help, rectX5, rectY5-50);
  } else {
    cursor(ARROW);
  }
  
  stroke(255);
  rect(rectX1, rectY1, rectSize, rectSize);
  rect(rectX2, rectY2, rectSize, rectSize);
  rect(rectX3, rectY3, rectSize, rectSize);
  rect(rectX4, rectY4, rectSize, rectSize);
  rect(rectX5, rectY5, rectSize, rectSize);
  
  image(IMG_upload, rectX1, rectY1);
  image(IMG_measure, rectX2, rectY2);
  image(IMG_download, rectX3, rectY3);
  image(IMG_exit, rectX4, rectY3);
  image(IMG_title, 5, 20);
  image(IMG_help, 550, 305);
  
  //visualizzo la quota a cui si è interrotta la stampa
  fill(0);
  text(numbers, (2*width/4-rectSize-36)-4*numbers.length(), height/1.9);
  
  fill(255, 0, 0);
  
  if(quota_valida == false){
    text("MEASURE NOT VALID!", 1*width/4-rectSize-40, 260+height/4);
  }
}

