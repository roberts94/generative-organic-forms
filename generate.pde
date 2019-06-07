import toxi.geom.*;
import toxi.geom.mesh.*;
import java.util.*;


//Parameters
float S, R, c1, c2, c3, c4;
float[] PARAMETERS = new float[]{S=1.1, R=10, c1=0.01, c2=0.005, c3=0.01, c4=0.1};
float threshold = 15;
float splitProb = 0.03;

//Mesh to be exported as OBJ file
TriangleMesh mesh = new TriangleMesh();
//Set of ALL live particles
static Set<Particle> all = new HashSet<Particle>();
//The 3D space broken into cubes to speed up collision calculation
ArrayList<HashSet<Particle>> cubes = new ArrayList<HashSet<Particle>>();  
//Contains particles to undergo mitosis
static Set<Particle> toSplit = new HashSet<Particle>();
//Size of each cube
int boxx;

void setup(){
  background(255);
  size(1000,1000, P3D);
  boxx = (int)((width)/PARAMETERS[1]);
  linkIcos();
  for (int i=0;i<boxx;i++){
    for (int j=0;j<boxx;j++){
      for (int k=0;k<boxx;k++){
        cubes.add(new HashSet<Particle>());
      }
    }
  }
}

void draw(){
    background(255);
    translate(width/2,width/2,width/2);  
     for (Particle i : all){
          i.applyForce();
          i.nutrient+=0.5;
          i.age+=1;
          float rand = random(1);
          if (i.nutrient>threshold && rand<splitProb){
            toSplit.add(i);
          } 
          i.display();     
      }
      for (Particle i : toSplit){
        i.split();
      }
      toSplit.clear();
}

//Exports current state of mesh as OBJ file upon keypress
void keyPressed(){
  createMesh(all);
}

void createMesh( Set<Particle> all ){
  for (Particle i : all){   
    for (Particle j : i.linked){
      for (Particle k : j.linked){
        if (k.isLinked(i)){       
          Vec3D x = new Vec3D(i.position.x,i.position.y,i.position.z);
          Vec3D y = new Vec3D(j.position.x,j.position.y,j.position.z);
          Vec3D z = new Vec3D(k.position.x,k.position.y,k.position.z);
          mesh.addFace(x,y,z);
        } 
      }
    }
  }  
  mesh.computeFaceNormals();
  mesh.saveAsOBJ(dataPath(""));
}
