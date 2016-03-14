// Barcelona PEV Simulation v0010
// for MIT Media Lab, Changing Place Group, CityScope Project

// by Udgam Goyal <udgam@mit.edu>
// Feb.8th.2015

class Nodes {
  ArrayList <Node> allNodes;

  Nodes() {
    allNodes = new ArrayList <Node>();
  }
  void addNodesToAllNodes(Roads roads1) {
    for (Road road : roads1.roads) {
      for (float t = 0.0; t<=1.0-(1.0/road.roadPts.length); t+=(1.0/road.roadPts.length)) {
        Node node1 = new Node(road.getPt(t), road.getNextPt(t), road);
        allNodes.add(node1);
      }
    }
  }
}