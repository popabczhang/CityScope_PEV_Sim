// Barcelona PEV Simulation v0010
// for MIT Media Lab, Changing Place Group, CityScope Project

// by Udgam Goyal <udgam@mit.edu>
// Feb.8th.2015

class Node {
  ArrayList <Road> Roads;
  String roadPtFile;
  PVector point;
  int id;
  Road roadOfNode;

  Node(PVector point1, int id1, Road road1) {
    point = point1;
    roadOfNode = road1;
    id = id1;
  }

  //void drawNode() {
  //stroke(255, 0, 0); //cyan
  //strokeWeight(1.0); 
  //line(start.x, start.y, end.x, end.y);
  //}
}