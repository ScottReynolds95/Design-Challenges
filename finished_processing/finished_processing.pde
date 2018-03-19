/**
 * Show GY521 Data.
 * 
 * Reads the serial port to get x- and y- axis rotational data from an accelerometer,
 * a gyroscope, and comeplementary-filtered combination of the two, and displays the
 * orientation data as it applies to three different colored rectangles.
 * It gives the z-orientation data as given by the gyroscope, but since the accelerometer
 * can't provide z-orientation, we don't use this data.
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
//  size(640, 360, P3D); 
  //size(1000, 1000, P3D);
  fullScreen(P3D);
  noStroke();
  colorMode(RGB, 256); 
  b = loadShape("body.obj");
  b.scale(5); 
  a = loadShape("arm.obj");
  a.scale(5); 

 
//  println("in setup");
  String portName = Serial.list()[portIndex];
//  println(Serial.list());
//  println(" Connecting to -> " + Serial.list()[portIndex]);
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
    
  // Tweak the view of the rectangles

  int x_rotation = 90;
  pushMatrix(); 
  draw_body();
  popMatrix();
  
  ////Show gyro data
  //pushMatrix(); 
  //translate(width/6, height/2, -50); 
  //rotateX(radians(-x_gyr - x_rotation));
  //rotateY(radians(-y_gyr));
  //draw_arm();
  
  //popMatrix(); 

  //Show accel data
  //pushMatrix();
  //translate(width/1.8, height/2.5); 
  //rotateX(radians(-x_acc - x_rotation));
  //rotateY(radians(-y_acc));
  //draw_arm();
  //popMatrix();
  
  //Show combined data
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
        /*
        print("Acc:");
        print(x_acc);
        print(",");
        print(y_acc);
        print(",");
        println(z_acc);
        */
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