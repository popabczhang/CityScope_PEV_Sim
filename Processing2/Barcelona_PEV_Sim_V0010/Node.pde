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

  void drawNode() {
    pushMatrix();
    translate(point.x, point.y);
    fill(0,255,0);
    ellipse(0, 0, 10, 10);
    popMatrix();
  }
}