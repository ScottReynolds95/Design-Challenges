PShape s;

void setup() {
 size(100, 100, P3D);
 // The file "bot.obj" must be in the data folder
 // of the current sketch to load successfully
 s = loadShape("piece.obj");
}

void draw() {
 background(204);
 translate(width/2, height/2);
 shape(s, 0, 0);
}