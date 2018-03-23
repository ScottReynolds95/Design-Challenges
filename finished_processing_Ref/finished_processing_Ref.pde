/**
 * 
 * 
 Please Note : All communication between the arduino and processing sketch have been taken from http://www.geekmomprojects.com/gyroscopes-and-accelerometers-on-a-chip/
 I have then changed the example animation processing sketch with two rhino sketches, one that is the solid body, the other the arm that is moving
 to complete my proof of concept, the programming behind the movement is credited to the above source 
 * 
 */
 
import processing.serial.*;

Serial  myPort;
short   portIndex = 0;
int     lf = 10;       //ASCII linefeed
String  inString;      //String for testing serial communication
int     calibrating;
 
float   dt;
float   x_gyr;  //Gyroscope data
float   y_gyr;
float   z_gyr;
float   x_acc;  //Accelerometer data
float   y_acc;
float   z_acc;
float   x_fil;  //Filtered data
float   y_fil;
float   z_fil;

PShape b;
PShape a;

void setup()  { 

  fullScreen(P3D);
  noStroke();
  colorMode(RGB, 256); 
  b = loadShape("body.obj");
  b.scale(5); 
  a = loadShape("arm.obj");
  a.scale(5); 


  String portName = Serial.list()[portIndex];
  myPort = new Serial(this, portName, 19200);
  myPort.clear();
  myPort.bufferUntil(lf);
} 

void draw_arm() {

 rotateX(radians(90));
 shape(a, 0, 0);
}

void draw_body() {
 translate(width/1.8, height/2.5); 
 rotateX(radians(90));
 shape(b, 0, 0);

}



void draw()  { 
  
  background(0);
  lights();

  int x_rotation = 90;
  pushMatrix(); 
  draw_body();
  popMatrix();
  

  pushMatrix();
  translate(width/1.8, height/2.5); 
  rotateX(radians(-x_fil - x_rotation));
  rotateY(radians(-y_fil));
  draw_arm();
  popMatrix();
  

} 

void serialEvent(Serial p) {

  inString = (myPort.readString());
  
  try {
    // Parse the data
    String[] dataStrings = split(inString, '#');
    for (int i = 0; i < dataStrings.length; i++) {
      String type = dataStrings[i].substring(0, 4);
      String dataval = dataStrings[i].substring(4);
    if (type.equals("DEL:")) {
        dt = float(dataval);
        /*
        print("Dt:");
        println(dt);
        */
        
      } else if (type.equals("ACC:")) {
        String data[] = split(dataval, ',');
        x_acc = float(data[0]);
        y_acc = float(data[1]);
        z_acc = float(data[2]);
        
      } else if (type.equals("GYR:")) {
        String data[] = split(dataval, ',');
        x_gyr = float(data[0]);
        y_gyr = float(data[1]);
        z_gyr = float(data[2]);
      } else if (type.equals("FIL:")) {
        String data[] = split(dataval, ',');
        x_fil = float(data[0]);
        y_fil = float(data[1]);
        z_fil = float(data[2]);
      }
    }
  } catch (Exception e) {
      println("Caught Exception");
  }
}