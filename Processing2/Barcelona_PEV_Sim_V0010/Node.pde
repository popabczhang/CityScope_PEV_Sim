// Barcelona PEV Simulation v0010
// for MIT Media Lab, Changing Place Group, CityScope Project

// by Udgam Goyal <udgam@mit.edu>
// Feb.8th.2015

class Node{
   ArrayList <Road> Roads;
   String roadPtFile;
   PVector start;
   PVector end;
   Road roadOfNode;

Node(PVector start1, PVector end1, Road road1){
       start = start1;
       end = end1;
       roadOfNode = road1;
}

void drawNode() {
      stroke(255, 0, 0); //cyan
      strokeWeight(1.0); 
      line(start.x, start.y, end.x, end.y);
  }




}