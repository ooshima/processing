import java.util.Iterator;

ArrayList<ParticleSystem> systems;
ArrayList<Particle> particles;

void setup(){
  size(640, 360);
  systems = new ArrayList<ParticleSystem>();
}

void draw(){
  background(100);
  PVector gravity = new PVector(0, 0.1);
  for (ParticleSystem ps: systems){
    ps.applyForce(gravity);
    ps.addParticle();
    ps.run();
  }
}

void mousePressed(){
  systems.add(new ParticleSystem(new PVector(mouseX, mouseY)));
}

class ParticleSystem {
  ArrayList<Particle> particles;
  //ArrayList<Confetti> confetti;
  
  PVector origin;
  
  ParticleSystem(PVector location){
    origin = location.get();
    particles = new ArrayList<Particle>();
  }
  
  void addParticle() {
    float r = random(1);
    if (r < 0.5) {
      particles.add(new Particle(origin));
    } else {
      particles.add(new Confetti(origin));
    }  
}
  
  void run() {
    Iterator<Particle> it = particles.iterator();
    while (it.hasNext()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
      }
    }
  }
  
  void applyForce(PVector f) {
    for (Particle p: particles) {
      p.applyForce(f);
    }
  }
}

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  
  float mass = 1;
  
  Particle(PVector l) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    location = l.get();
    lifespan = 255;
  }
  
  void run(){
    update();
    display();
  }
  
  void update(){
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    lifespan -= 2.0;
  }

  void applyForce(PVector force){
    PVector f = force.get();
    f.div(mass);
    acceleration.add(f);
  }  
  
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(location.x, location.y, 8, 8);
  }
  
    boolean isDead(){
    if(lifespan < 0.0){
      return true;
    } else {
      return false;
    }
  }
}

class Confetti extends Particle {
  
  Confetti(PVector l){
    super(l);
  }
  
  void display() {
    float theta = map(location.x, 0, width, 0, TWO_PI*2);
    
    rectMode(CENTER);
    fill(175, lifespan);
    stroke(0, lifespan);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    rect(0, 0, 8, 8);
    popMatrix();
  }
}