import processing.opengl.*;

/** 
binarymillenium
GPL v3.0
June 2009

*/

import toxi.geom.*;

body vehicle; 
movable cam;

terrain land;

void drawArrow(float len, float rad, color col ) {
  pushMatrix();
        
  noStroke();
 
  fill(col);
    
      /// body drawing
      int sides = 8;
      float angleIncrement = TWO_PI/sides;
      float angle = 0;  
      
      /// draw cylind
      beginShape(TRIANGLE_STRIP);
       for (int i = 0; i < sides + 1; i++) {
        vertex(0, rad * cos(angle),  rad * sin(angle));
        vertex( len, rad * cos(angle),  rad * sin(angle));
        angle += angleIncrement;
      }
      endShape();
      
      beginShape(TRIANGLE_FAN);
      // Center point
      vertex(len*1.3, 0, 0);
      for (int i = 0; i < sides + 1; i++) {
        vertex(len, rad*2 * cos(angle),  rad*2 * sin(angle));
        angle += angleIncrement;
      }
      endShape();  

  popMatrix();  
}



void setup() {
  size(800,600,P3D); 
  frameRate(15);
 
  vehicle = new body();
  cam = new body();
  cam.target = vehicle;
  cam.pos = new Vec3D(300,300,800);
   cam.offset = new Vec3D(0,0,520);
  //land = new terrain("G:/other/western_wa/ned_1_3_78184666/78184666");
  //land = new terrain("78184666");
}

//////////////////////////////////////////////////////

float increase(float x) {
     x += 1; 
       
   if (x > 0) cam.vel.x *= 1.2;
   else x *= 0.9;
   
   return x;
  
}

float decrease(float x) {
  x -= 1.1; 
       
  if (x < 0) x *= 1.2;
  else x *= 0.9;
  
  return x;
}

void keyPressed() {
 //if (keyPressed) {
   
    if (key == 'a') {
       Vec3D dir = rotateAxis(cam.rot, new Vec3D(1,0,0));
       cam.vel = cam.vel.add(dir.scale(10) );
       println(cam.offsetVel.x);
    }
    if (key == 'd') {
        Vec3D dir = rotateAxis(cam.rot, new Vec3D(-1,0,0));
       cam.vel= cam.vel.add(dir.scale(10) );
    }
    if (key == 'q') {
       Vec3D dir = rotateAxis(cam.rot, new Vec3D(0,1,0));
       cam.vel = cam.vel.add(dir.scale(10) );
    }
    if (key == 'z') {
       Vec3D dir = rotateAxis(cam.rot, new Vec3D(0,-1,0));
       cam.vel = cam.vel.add(dir.scale(10) ); 
    }
    if (key == 'w') {
       Vec3D dir = rotateAxis(cam.rot, new Vec3D(0,0,1));
       cam.vel = cam.vel.add(dir.scale(10) );
    }
    if (key == 's') {
       Vec3D dir = rotateAxis(cam.rot, new Vec3D(0,0,-1));
       cam.vel = cam.vel.add(dir.scale(10) );
    }    
    if (key == 'e') {
       cam.offsetVel.z = increase(cam.offsetVel.z); 
       println(cam.offset.z); 
    }
    if (key == 'c') {
      cam.offsetVel.z = decrease(cam.offsetVel.z);
      //println(cam.offset.z);
    }
    
    if (key == 't') {
      cam.aimTracking = !cam.aimTracking;  
      if (cam.aimTracking) {
         println("aiming ");
      } else {
         println(" not aiming"); 
      }
    }
    
    if (key == 'b') {
      Vec3D dir = rotateAxis(vehicle.rot, new Vec3D(1,0,0));
      vehicle.vel = vehicle.vel.add(dir.scale( 13+ random(13.0)) );
      println(vehicle.vel.x + ", " + vehicle.vel.y + ", " + vehicle.vel.z);    
    }
//}
}

void handleMouse() {
  if (mousePressed) {
    float dx = (mouseX - oldMouseX)/500.0;
    float dy = (mouseY - oldMouseY)/500.0;  
   
    if (mouseButton != CENTER ) {
      /*
      println("start " + cam.rot.toArray()[0] + " " + 
              cam.rot.toArray()[1] + " " + 
              cam.rot.toArray()[2] + " " +
              cam.rot.toArray()[3]  );*/
      
      //cam.rot = cam.rot.normalize();  
      /// the ordering is xyzw, not wxyz

      Vec3D axis;
      if (mouseButton == RIGHT) {
        axis = new Vec3D(0,0,-1);
        cam.rotateAbs(-dx, axis);
      } else {
        axis = new Vec3D(0,1,0);
        cam.rotateBody(dx, axis);
      }
      
      Vec3D y_axis = new Vec3D(-1,0,0);
      cam.rotateAbs(-dy, y_axis);
      //cam.rotateBody(-dy, y_axis);
    } else {
    
       vehicle.pqr.y += dx;
       vehicle.pqr.x += dy;
     }
  } 

  oldMouseX = mouseX;
  oldMouseY = mouseY;
}

float clamp(float a, float b, float c) { 
	   return (a < b ? b : (a > c ? c : a)); 
} 
    
void drawGround() {
  float r = terrain.EARTH_CIRC_EQ;
  
  noStroke();
 //stroke(255,0,0);
 
  int maxInd = 64;
  pushMatrix();
   translate(-0, -1.00001*r, 0);
   //translate(-0, -1.1*r, 0);
   rotateX(-PI/2);
  for (int i = 0; i < maxInd; i++) {
      beginShape(TRIANGLE_STRIP); 
      float f1 = (float)i/(float)maxInd;
      float f2 = (float)(i+1)/(float)maxInd;
       float psi = f1*PI/8 + 3*PI/8;
       float psi2= f2*PI/8 + 3*PI/8;
     
       for (int j = 0; j <= maxInd; j++) {  
            float cdiv = 10.0; 

            float y = (j==maxInd)?0:j;
    
           color col1 = color(10,80*noise(i/cdiv+1000,y/cdiv+1000),200+55*noise(i/cdiv,y/cdiv)) ;
           color col2 = color(0,80*noise((i+1)/cdiv+1000,y/cdiv+1000),200+55*noise((i+1)/cdiv,y/cdiv));
           if (i+1 == maxInd) {
             col2 = color(0,80*noise(1000,0/cdiv+1000),200+55*noise(0,0/cdiv));
           }
           
         float theta = (float)j/(float)maxInd*2*PI;
          fill(col1);
          vertex( r*cos(theta)*cos(psi),  r*sin(theta)*cos(psi),  r*sin(psi));// (float)j/(float)maxInd*100.0,     (float)i/(float)maxInd*100.0);
          fill(col2);
          vertex( r*cos(theta)*cos(psi2), r*sin(theta)*cos(psi2), r*sin(psi2));// (float)(j)/(float)maxInd*100.0, (float)(i+1)/(float)maxInd*100.0);
        }
      
       endShape(); 
    }
  popMatrix();
 
  hint(DISABLE_DEPTH_TEST);
  hint(ENABLE_DEPTH_TEST);
}

void  drawSky() {
  background(0);
  noStroke();
  
  float h = clamp(-cam.pos.y/30e3,0,1);
  
    pushMatrix();
    
    translate(-cam.pos.x, -cam.pos.y, -cam.pos.z);
    
    noStroke();
    //stroke(255,255,50);

    rotateX(-PI/2);
    
    float r = 1000.0;
    int maxInd = 24;
    
    for (int i = 0; i < maxInd; i++) {
      beginShape(QUAD_STRIP); 
      float f1 = (float)i/(float)maxInd;
      float f2 = (float)(i+1)/(float)maxInd;
       float psi = f1*PI-PI/2;
       float psi2= f2*PI-PI/2;
       
       color top = lerpColor(color(20,20,255), color(0,0,0), h );
      
       for (int j = 0; j <= maxInd; j++) {  
         float theta = (float)j/(float)maxInd*2*PI;
          fill(lerpColor(color(255,255,255),top, (f1 > 0.5) ? (f1-0.5)*2 : 0 ));
          vertex( r*cos(theta)*cos(psi),  r*sin(theta)*cos(psi),  r*sin(psi));// (float)j/(float)maxInd*100.0,     (float)i/(float)maxInd*100.0);
          fill(lerpColor(color(255,255,255),top, (f2 > 0.5) ? (f2-0.5)*2 : 0 ));
          vertex( r*cos(theta)*cos(psi2), r*sin(theta)*cos(psi2), r*sin(psi2));// (float)(j)/(float)maxInd*100.0, (float)(i+1)/(float)maxInd*100.0);
        }
      
       endShape(); 
    }
    // vertex( 10,  10, 0, 100, 100);
    // vertex(-10,  10, 0, 0,   100);

  
    popMatrix(); 
  /*
  beginShape();
  fill(lerpColor( color(20,20,255), color(0,0,0), clamp(-cam.pos.y/30e3,0,1) ));
  println("z " + cam.pos.y);
  vertex(-width/2, -height/2);
  fill(lerpColor( color(20,20,255), color(0,0,0), clamp(-cam.pos.y/30e3,0,1) ));
  vertex( width/2, -height/2);  
  fill(255,255,255);
  vertex( width/2,  0);  
  fill(255,255,255);
  vertex(-width/2,  0);  
      
  endShape();
  
    beginShape();
  fill(255,255,255);
  vertex(-width/2, 0);
  fill(255,255,255);
  vertex( width/2, 0);  
  fill(255,255,255);
  vertex( width/2,  height/2);  
  fill(255,255,255);
  vertex(-width/2,  height/2);  
  
  
      
  endShape();
  */
  
  
    hint(DISABLE_DEPTH_TEST);
  hint(ENABLE_DEPTH_TEST);
  
}
////////////////////////////////////////////////////////////////////////////////

float time = 0;
float oldMouseX = 0;
float oldMouseY = 0;

void draw() {
  
  handleMouse();
 
  
  //println("test");
  time += 0.01;
  
  //background(128);
  
  /////// update
   
  cam.update();
  cam.vel = cam.vel.scale(0.9);
  cam.offsetVel = cam.offsetVel.scale(0.9);
  cam.pqr = cam.pqr.scale(0.8);
 
  
  //translate(cam.pos.x,cam.pos.y,cam.pos.z);
  
//  vehicle.pqr.x += 0.008*(noise(time)-0.5);
//  vehicle.pqr.y += 0.004*(noise(1000+time)-0.5);  
//  vehicle.pqr.z += 0.0021*(noise(2000+time)-0.5); 
  
  vehicle.vel = vehicle.vel.scale(0.8);
       vehicle.pqr.x *= 0.9;
      vehicle.pqr.y *= 0.9;
      vehicle.pqr.z *= 0.9; 
      
  
  vehicle.update();
  //println(vehicle.vel.x + ", " +vehicle.pos.x);
  /////////////////////////////////////////
  /// draw
  
  pushMatrix();
  translate(width/2,height/2); 

  
  /// the camera needs an applyInverse()
   cam.applyInv();
     drawSky();
     drawGround();
    drawGrid();
  //land.draw();

  //rotateZ(-PI/2);
 
  vehicle.draw();
  
  popMatrix();
}


void drawGrid() {
  float sc = 1;
   // draw grid
    int maxGridInd = 20;
    float spacing = 3000*sc;
    for (int i = 0; i < maxGridInd; i++) { 
      stroke(220,130,5);
      float xorz = i*spacing-  maxGridInd/2*spacing;
      line(-maxGridInd/2*spacing,50, xorz, maxGridInd/2*spacing,50, xorz);
      /// depth testing seems to be done only on the nearest part of the line, not each
      /// pixel
      stroke(120,190,5); 
      line(xorz, 50, -maxGridInd/2*spacing,  xorz, 50,maxGridInd/2*spacing);
  } 
}