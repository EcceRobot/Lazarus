int j, line_start_delete, line_end_delete, n_layer, tot_layer;
float h, layer_height;
char data[] = {
  ' ', ',', ';'
}; //caratteri che delimitano parole
String delimiters = new String(data);
String[] Array_parole_file;    // Array contenente tutte le parole
String[] Array_parole_riga;    // Array contenente tutte le parole di una specifica riga
String E_partenza;
String[] lines;
PFont font;
String nome_file;
boolean quota_valida = true;
boolean SAVE = false;
boolean Abilitazione_scrittura = false;
boolean view_help;
double t1, t2;


//immagini
PImage IMG_upload;
PImage IMG_measure;
PImage IMG_download;
PImage IMG_exit;
PImage IMG_title;
PImage IMG_load;
PImage IMG_height;
PImage IMG_save;
PImage IMG_close;
PImage IMG_help;


void setup() { 

  IMG_download = loadImage("download.png");
  IMG_measure = loadImage("measure.png");
  IMG_exit = loadImage("exit.png");
  IMG_upload = loadImage("upload.png");
  IMG_title = loadImage("title.png");
  IMG_load = loadImage("load.png");
  IMG_height = loadImage("height.png");
  IMG_save = loadImage("save.png");
  IMG_close = loadImage("close.png");
  IMG_help = loadImage("help.png");



  size(640, 360);

  //dimensioni dei riquadri
  rectX1 = 1*width/5-rectSize-20;
  rectY1 = height/2-rectSize/2;
  rectX2 = 2*width/5-rectSize-20;
  rectY2 = height/2-rectSize/2;
  rectX3 = 3*width/5-rectSize-20;
  rectY3 = height/2-rectSize/2;
  rectX4 = 4*width/5-rectSize-20;
  rectY4 = height/2-rectSize/2; 
  rectX5 = 5*width/5-rectSize-20;
  rectY5 = height/2-rectSize/2;
}  

void fileSelected(File selection) { 
  //////////////////////////////////////////////////////
  //carico il file come array di stringhe
  String[] lines = loadStrings(selection.getAbsolutePath());
  /////////////////////////////////////////////////////

  nome_file = selection.getAbsolutePath();

  t1 = millis();

  println("il file in uso è: "+ nome_file);

  //identifico il numero di righe/stringhe che lo compongono
  println(lines.length + " linee nel file");

  // Join all the text into one long string
  String everything = join(lines, "" );
  // Now make the declared array called Array_parole_file_file,
  // to include all text as single words and remove delimiters
  Array_parole_file = splitTokens(everything, delimiters);

  //identifico il valore di layer_height
  for (int i = 0; i < Array_parole_file.length; i++) {
    if (Array_parole_file[i].equals("Layer") && Array_parole_file[i+1].equals("height:")) { 
      println("Il layer height è: " + Array_parole_file[i+2]);
      layer_height = float(Array_parole_file[i+2]);
      i = Array_parole_file.length;
    } //else println("ERROR: IMPOSSIBILE IDENTIFICARE LAYER HEIGHT");
  } 

  //quanti layer ci sono? lo leggo all'inizio del gcode
  for (int i = 0; i < Array_parole_file.length; i++) {
    if (Array_parole_file[i].equals("Layer") && Array_parole_file[i+1].equals("count:")) { 
      println("Ci sono in totale " + Array_parole_file[i+2] + " layer nel file");
      tot_layer = int(Array_parole_file[i+2]);
      i = Array_parole_file.length;
    } //else println("ERROR: IMPOSSIBILE IDENTIFICARE NUMERO TOTALE DI LAYER");
  }


  h = float(numbers);

  //identifico il layer al quale si è interrotta la stampa
  n_layer = int(h/layer_height);

  //trovo nel file il LAYER 0 
  for (j=0; j<lines.length; j++) {    
    if (lines[j].equals(";LAYER:0")) {
      line_start_delete = j;
      j=lines.length;
    } //else println("ERROR: LAYER 0 DEL GCODE ORIGINALE NON IDENTIFICATO");
  }  

  //trovo nel file il LAYER N
  for (j=0; j<lines.length; j++) {    
    if (lines[j].equals(";LAYER:" + n_layer)) {
      line_end_delete = j;
      j=lines.length;
    } //else println("ERROR: LAYER DA CUI RIPARTIRE NON IDENTIFICATO");
  }      

  //stabilisco se la quota inserita a video è compatibile con il pezzo in stampa 
  if (n_layer <= tot_layer) {
    quota_valida = true;
  } 
  else {
    quota_valida = false;
    println("ERROR: QUOTA INSERITA NON VALIDA");
  }

  //identifico il valore di E da cui ripartire 
  for (j=line_end_delete; j < lines.length; j++) {     
    Array_parole_riga = splitTokens(lines[j], delimiters);
    for (int k=0; k < Array_parole_riga.length; k++) {
      if (Array_parole_riga[k].substring(0, 1).equals("E")) { 
        E_partenza = Array_parole_riga[k];
        println("Il valore di partenza di E: " + E_partenza);
        j=lines.length;
      }
    }
  }


  //identifico il comando che mi manda l'estrusore in basso   
  for (j=0; j < line_start_delete; j++) {     
    Array_parole_riga = splitTokens(lines[j], delimiters);
    for (int k=0; k < Array_parole_riga.length; k++ ) {      
      if (Array_parole_riga[k].equals("G1") && Array_parole_riga[k+1].substring(0, 1).equals("Z")) {         
        lines[j] = "; STOPPED BY LAZARUS!  " + lines[j];
        j=lines.length;
      }
    }
  }


  //info per debug
  println("cancellazione dalla linea " + line_start_delete + " fino alla " + line_end_delete);
  println("cioè dal layer #0 al layer #" + n_layer);

  //creo due array, prima e dopo quello che devo eliminare, e poi li riunisco

  String[] sa1 = subset(lines, 0, line_start_delete);
  String[] sa2 = subset(lines, line_end_delete);
  lines = concat(sa1, sa2);




  //trovo E0 e lo sostituisco con E_partenza
  for (j=0; j<lines.length; j++) {    
    if (lines[j].equals("G92 E0                  ;zero the extruded length again")) {
      Array_parole_riga = splitTokens(lines[j], delimiters);
      for (int k=0; k<Array_parole_riga.length; k++) {
        if (Array_parole_riga[k].equals("E0")) {
          Array_parole_riga[k] = E_partenza + "  ;";
        }
      } 
      String re_stringato = join(Array_parole_riga, " " );
      lines[j] = re_stringato; 
      j=lines.length;
    } //else println("Errore con identificazione E0 nel file");
  }


  /*
  //identificazione del valore E3 e sostituzione 
   String E_partenza3 = E_partenza;
   E_partenza3 = E_partenza3.substring(1);
   float E_partenza3_float = float(E_partenza3);
   E_partenza3_float = E_partenza3_float + 3.0;
   String E_partenza_str = str(E_partenza3_float);
   for(j=0; j<lines.length; j++){    
   if (lines[j].equals("G1 F200 E3              ;extrude 3mm of feed stock")){
   Array_parole_riga = splitTokens(lines[j],delimiters);
   for(int k=0; k<Array_parole_riga.length;k++ ){
   if(Array_parole_riga[k].equals("E3")) {
   Array_parole_riga[k] = "E"+E_partenza_str+"  ;";
   }  
   } 
   String re_stringato = join(Array_parole_riga, " " );
   lines[j] = re_stringato; 
   j=lines.length;  
   }  
   }
   */

  if (quota_valida == true) { 
    nome_file = nome_file.substring(0, nome_file.length()-6);
    saveStrings(nome_file + "_Lazarus.gcode", lines);
    println("File salvato come: " + nome_file +"_Lazarus.gcode");
  } 
  else {
  }


  // calcolo tempo di esecuzione del ciclo
  t2 = millis() - t1;
  println("Tempo di esecuzione: " + t2/1000 + " sec");
}

