//Initialize Icosahedron

float t = (1.0 + sqrt(5.0)) / 2.0;
float r =3;

//Initialize location of Icosaheron's 20 vertices
Particle p1 = new Particle(-1*r,  t*r,  0, PARAMETERS);
Particle p2 = new Particle(1*r,  t*r,  0, PARAMETERS);
Particle p3 = new Particle(-1*r,  -t*r,  0, PARAMETERS);
Particle p4 = new Particle(1*r,  -t*r,  0, PARAMETERS);
Particle p5 = new Particle(0,  -1*r,  t*r, PARAMETERS);
Particle p6 = new Particle(0,  1*r,  t*r, PARAMETERS);
Particle p7 = new Particle(0,  -1*r,  -t*r, PARAMETERS);
Particle p8 = new Particle(0,  1*r,  -t*r, PARAMETERS);
Particle p9 = new Particle(t*r,  0,  -1*r, PARAMETERS);
Particle p10 = new Particle(t*r,  0,  1*r, PARAMETERS);
Particle p11 = new Particle(-t*r,  0,  -1*r, PARAMETERS);
Particle p12 = new Particle(-t*r,  0,  1*r, PARAMETERS);

//Link appropriate vertices to form Icosahedron's edges
void linkIcos() {
  p1.link(p2);
  p1.link(p8);
  p1.link(p11);
  p1.link(p12);
  p1.link(p6);
  p2.link(p8);
  p2.link(p9);
  p2.link(p6);
  p2.link(p10);
  p3.link(p11);
  p3.link(p7);
  p3.link(p4);
  p3.link(p5);
  p3.link(p12);
  p4.link(p10);
  p4.link(p5);
  p4.link(p7);
  p4.link(p9);
  p5.link(p12);
  p5.link(p6);
  p5.link(p10);
  p6.link(p10);
  p6.link(p12);
  p7.link(p9);
  p7.link(p8);
  p7.link(p11);
  p8.link(p11);
  p8.link(p9);
  p9.link(p10);
  p11.link(p12);
}
  
