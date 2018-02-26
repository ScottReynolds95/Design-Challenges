PShape b;
PShape a;


void setup() {
fullScreen(P3D);
 // The file "bot.obj" must be in the data folder
 // of the current sketch to load successfully
 
 //b = loadShape("body.obj");
 //b.scale(5); 
 a = loadShape("arm.obj");
 a.scale(5); 


}

void draw() {
 
 translate(width/1.8, height/2.5); 
 rotateX(radians(90));
 //shape(b, 0, 0);
 shape(a, 0, 0);
}