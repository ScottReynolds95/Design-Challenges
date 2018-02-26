PShape s;

void setup() {
fullScreen(P3D);
 // The file "bot.obj" must be in the data folder
 // of the current sketch to load successfully
 s = loadShape("piece.obj");
 s.scale(5); 
}

void draw() {
 background(204);
 
 translate(width/1.8, height/2.5); 
 rotateX(radians(90));
 shape(s, 0, 0);
}