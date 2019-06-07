class Particle {
  PVector position;
  PVector normal;
  float S;
  float R;
  float c1;
  float c2;
  float c3;
  float c4;
  float nutrient;
  int age;
  boolean frozen;  
  Set<Particle> linked; 
  
  public Particle(float x, float y, float z, float[] PARAMETERS) {
    position = new PVector(x, y, z);
    normal = new PVector (0, 0, 0);
    S = PARAMETERS[0];
    R = PARAMETERS[1];
    c1 = PARAMETERS[2];
    c2 = PARAMETERS[3];
    c3 = PARAMETERS[4];
    c4 = PARAMETERS[5];
    linked = new HashSet<Particle>();
    frozen = false;
    nutrient = 0; 
    age = 0;
    all.add(this);   
  }
   //<>//
  //Link two particles 
  void link(Particle toLink) {
    this.linked.add(toLink);
    toLink.linked.add(this);
  }

  //Unlink two particles
  void unLink(Particle toLink) {
    this.linked.remove(toLink);
    toLink.linked.remove(this);
  }

  //Determine whether two particles are linked
  boolean isLinked(Particle toLink) {
    if (this.linked.contains(toLink)) {
      return true;
    } else {
      return false;
    }
  }
  
  //Calculate the SPRING force for the current particle
  
  //Strength of force determined by c1
  PVector calcSpring() {
    PVector force = new PVector(0, 0, 0);
    if (this.linked.size()==0) {
      return force;
    } else {
      for (Particle temp : this.linked) {
        PVector thisCopy = new PVector(this.position.x, this.position.y, this.position.z);
        PVector tempCopy = new PVector(temp.position.x, temp.position.y, temp.position.z);
        PVector subbed = PVector.sub(tempCopy,thisCopy);
        subbed.normalize();
        force.add(subbed);
      }
      float size = this.linked.size();
      force.mult(S/size);
      return force;
    }
  }

  //Calculate the PLANAR force for the current particle
  
  //Strength of force determined by c2
  PVector calcPlanar() {
    PVector force = new PVector(0, 0, 0);
    if (this.linked.size()==0) {
      return force;
    } else {
      for (Particle temp : this.linked) {
        force.add(temp.position);
      }
      float size = this.linked.size();
      force.mult(1/size);
      return force;
    }
  }

  //Calculate the BULGE force for the current particle
  
  //Strength of force determined by c3
  PVector calcBulge() {
    PVector force = new PVector(0, 0, 0);
    if (this.linked.size()==0) {
      return force;
    } else {
      float nfin = 0;
      for (Particle temp : this.linked) {
        PVector thisCopy = new PVector(this.position.x, this.position.y, this.position.z);
        PVector tempCopy = new PVector(temp.position.x, temp.position.y, temp.position.z);
        PVector normCopy1 = new PVector(this.normal.x, this.normal.y, this.normal.z);
        PVector v1 = PVector.sub(thisCopy,tempCopy);
        PVector v2 = normCopy1.mult(S);
        float theta = PVector.angleBetween(v1, v2);
        PVector subbed = PVector.sub(tempCopy,thisCopy);
        float n = sq(S) + sq(subbed.mag()) - 2*S*subbed.mag()*cos(theta);
        nfin += sqrt(max(n, 0));
      }
      force = new PVector(this.normal.x, this.normal.y, this.normal.z);  
      float size = this.linked.size();
      force.mult(nfin/size);
      return force;
    }
  }

  //Calculate the COLLISION force for the current particle
  
  //Strength of force determined by c4
  PVector calcColl() {
    PVector force = new PVector(0, 0, 0);
    Set<Particle> C = new HashSet<Particle>();
    float indexx = this.position.x;
    float indexy = this.position.y;
    float indexz = this.position.z;
    int index_x = (int)((int)(indexx + (width/2))/R);
    int index_y = (int)((int)(indexy + (width/2))/R);
    int index_z = (int)((int)(indexz + (width/2))/R);     
    for (int i = -1; i<2; i++) {
      for (int j = -1; j<2; j++) {
        for (int k = -1; k<2; k++) {  
          if (index_x+i>=0 && index_x+i<=boxx && index_y+i>=0 && index_y+i<=boxx && index_z+i>=0 && index_z+i<=boxx){
            for (Particle temp : cubes.get((int)((index_z+k)*boxx*boxx)+(int)((index_y+j)*boxx)+(int)(index_x+i))) {
              PVector thisCopy = new PVector(this.position.x, this.position.y, this.position.z);
              PVector tempCopy = new PVector(temp.position.x, temp.position.y, temp.position.z);
              PVector subbed = PVector.sub(thisCopy,tempCopy);
              float check = subbed.mag();
              if (!temp.linked.contains(this)&&check<R) {
                C.add(temp);
              }
            }
          }
        }
      }
    }
    for (Particle temp : C) {
      PVector thisCopy = new PVector(this.position.x, this.position.y, this.position.z);
      PVector tempCopy = new PVector(temp.position.x, temp.position.y, temp.position.z);
      PVector subbed = PVector.sub(thisCopy,tempCopy);
      float n = (sq(R) - subbed.magSq())/sq(R);  
      subbed.normalize();  
      subbed.mult(n);
      force.add(subbed);
    }   
    float size = C.size();
    force.mult(1/size);
    return force;
  }

  //Calculate the NORMAL for the current particle
  void calcNormal() {
    ArrayList<Particle> ring = getRing();
    if (ring.size()==0) {
      frozen=true;
    } else {
      frozen=false;
      PVector force = new PVector(0, 0, 0);
      for (int i=0; i<ring.size()-2; i++) {
        PVector get1aCopy = new PVector(ring.get(i).position.x, ring.get(i).position.y, ring.get(i).position.z);
        PVector get1bCopy = new PVector(ring.get(i).position.x, ring.get(i).position.y, ring.get(i).position.z);
        PVector get2Copy = new PVector(ring.get(i+1).position.x, ring.get(i+1).position.y, ring.get(i+1).position.z);
        PVector thisCopy = new PVector(this.position.x, this.position.y, this.position.z);
        PVector subbed1 = PVector.sub(get1aCopy,thisCopy);
        PVector subbed2 = PVector.sub(get2Copy,get1bCopy);
        PVector cross = subbed1.cross(subbed2);
        force.add(cross);
      }
      this.normal = force.normalize();
    }
  }

  //Return an ArrayList of the Particles that form a ring around the current particle
  ArrayList<Particle> getRing() {
    ArrayList<Particle> ring = new ArrayList<Particle>();
    if (this.linked.size()<3) {
      return ring;
    } else {
      Set<Particle> clone = new HashSet<Particle>();
      ArrayList<Particle> rando = new ArrayList<Particle>();
      for (Particle i : this.linked) {
        clone.add(i);
        rando.add(i);
      }
      int random = (int)random(this.linked.size());
      Particle check = rando.get(random);
      clone.remove(check);
      ring.add(check);
      for (int i = 0; i<this.linked.size()-1; i++) {
        for (Particle temp : clone) {
          if (check.isLinked(temp)) {
            check = temp;
            clone.remove(check);    
            ring.add(check);    
            break;
          }
        }
      }
      if (ring.size()==this.linked.size()&&ring.get(ring.size()-1).isLinked(ring.get(0))) {  
        ring.add(ring.get(0));
        return ring;
      } else {
        ring.clear();
        return ring;
      }
    }
  }

  //Return indices of particles along shortest axis on ring
  int [] getShort(ArrayList<Particle> thing) {
    ArrayList<Particle> ring = thing;
    int [] index = new int[2];
    PVector apos1 = ring.get(0).position;
    PVector bpos1 = ring.get((int)(ring.size()/2)).position;
    float shortlen = apos1.dist(bpos1);
    for (int i=0; i<ring.size()-1; i++) {
      PVector apos = ring.get(i).position;
      PVector bpos = ring.get((i+(int)(ring.size()/2))%ring.size()).position;
      if (apos.dist(bpos)<=shortlen) {
        shortlen = apos.dist(bpos);
        index[0]=i;
        index[1]=(i+(int)(ring.size()/2))%ring.size();
      }
    }
    return index;
  }

  //Split the ring around the current particles into 2 rings along the shortest axis
  //Creates new particle
  void split() {
    ArrayList<Particle> ring = getRing();
    if (ring.size()>3) {
      ring.remove(ring.size()-1);
      int [] shortRing = getShort(ring);
      for (int i =min(shortRing[0], shortRing[1])+1; i<=max(shortRing[0], shortRing[1])-1; i++) {
        this.unLink(ring.get(i));
      }
      Particle fresh = new Particle(this.position.x, this.position.y, this.position.z, PARAMETERS);
      this.link(fresh);
      for (int i =min(shortRing[0], shortRing[1]); i<=max(shortRing[0], shortRing[1]); i++) {
        fresh.link(ring.get(i));
      }       
      PVector posCopy = new PVector(this.position.x,this.position.y,this.position.z);
      fresh.position = posCopy;
      fresh.nutrient=0;
      this.nutrient=0;
      all.add(fresh);
    }
  }

  
  //Apply each force to the current particle and update position.
  void applyForce() {
     
    float indexx = this.position.x;
    float indexy = this.position.y;
    float indexz = this.position.z;
    int index_x = (int)((int)(indexx + (width/2))/R);
    int index_y = (int)((int)(indexy + (width/2))/R);
    int index_z = (int)((int)(indexz + (width/2))/R);       
    cubes.get(index_z*boxx*boxx + index_y*boxx + index_x).add(this);
   
    calcNormal();
    PVector spring = calcSpring().mult(c1);
    PVector planar = calcPlanar().mult(c2);
    PVector bulge = calcBulge().mult(c3);
    PVector coll = calcColl().mult(c4);
    PVector force = spring.add(planar).add(bulge).add(coll);
    
    cubes.get(index_z*boxx*boxx + index_y*boxx + index_x).remove(this);
    
    this.position.add(force);   
   
    indexx = this.position.x;
    indexy = this.position.y;
    indexz = this.position.z;
    index_x = (int)((int)(indexx + (width/2))/R);
    index_y = (int)((int)(indexy + (width/2))/R);
    index_z = (int)((int)(indexz + (width/2))/R);    
    cubes.get(index_z*boxx*boxx + index_y*boxx + index_x).add(this);
  }

  //Display the particle
  void display() {
    strokeWeight(1);
    for (Particle temp : linked) { 
      line(this.position.x, this.position.y, this.position.z, temp.position.x, temp.position.y, temp.position.z);
    }
  }
}
