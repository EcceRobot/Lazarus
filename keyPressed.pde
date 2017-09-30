void keyPressed() {
  if (key == BACKSPACE) {
    if (numbers.length() > 0) {
      numbers = numbers.substring(0, numbers.length()-1);
    }
  } else if (textWidth(numbers+key) < width && Abilitazione_scrittura == true) {              //ammetto il test digitato solo se sono abilitato alla scrittura con pressione del riquadro
    numbers = numbers + key;
    } 
}

