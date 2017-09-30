void mousePressed() {
  if (rect1Over) {
    selectInput("Select a file to process:", "fileSelected");
  } else if (rect2Over){
  Abilitazione_scrittura = true;          // se clicco mi abilito alla scrittura
  } else if (rect3Over){
    SAVE = true; 
  } else if (rect4Over){
    exit();
  } else if (rect5Over){
    view_help = true;
  }
  }
