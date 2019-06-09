# Generative Organic Forms

This project aims to model an evolving system of cells that undergo mitosis and react with a variety of systemic and external forces. Implemented in Processing, it currently outputs a 3D mesh (.OBJ) of the particle system's state upon keypress. Inspiration for this project was drawn from [Digital Morphologies: Environmentally-Influenced Generative Forms](https://drive.google.com/file/d/0B_4X5OQcV3d8Y3JYWFBpU1ZWbHM/view) by Sage Jenson. 
![](gof1.gif)

## Initial State
The form begins as a collection of 20 [particles](particle.pde) **P**, each with a position **p** and normal **n** in **R^3**, along with a set of linked particles **L**. They are arranged into an [icosahedron](icosahedron.pde) with the particles as vertices and linkages as edges. 
![](icos.png)


## Forces
### Spring
The spring force acts as a linear spring aiming to maintain a fixed distance **S**
between linked cells. Every timestep the displacement due to the spring force is
calculated as the average of these linear springs.

![](/equations/eq1.jpg)

### Planar
The planar force pushes the particle towards the average position of its linked
neighbors, encouraging the mesh to return to a locally planar state.

![](/equations/eq2.jpg)

### Bulge 
The bulge force pushes the particle out in the direction of the normal when linked
particles are closer than **S**, the link length. The magnitude of the bulge force is
how far, on average, the particle would have to move along the normal to allow the links to
return to an uncompressed state. For each linked particle i ∈ **L**, let **θ** be defined
as the angle between points **p**, **p_i**, and **t**; where **t** is the point **S** distance from **p_i**
along **n**.

![](/equations/eq3.jpg)

### Collision
The collision force repels physically close particles to avoid intersection, acting on
pairs of unlinked particles that are closer than a fixed radius **R**. The magnitude of
the force is proportional to the average of the inverse square of the distance. Define **C** to be the collection of 
particles not linked to the current particle, yet closer than **R** to the current particle.

![](/equations/eq4.jpg)


## Mitosis

## Parameters

## Conclusion


