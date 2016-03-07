// Barcelona PEV Simulation v0010
// for MIT Media Lab, Changing Place Group, CityScope Project

// by Udgam Goyal <udgam@mit.edu>
// Feb.8th.2015

class Path {
  ArrayList <Road> Roads;
  String roadPtFile;
  ArrayList <Node> allNodes;
  ArrayList <Node> pathOfNodes;
  boolean pathPresent = false;

  Path() {
    allNodes = new ArrayList <Node>();
    pathOfNodes = new ArrayList <Node>();
  }

  // Successors function
  ArrayList <Node> successors(Node parent) {
    ArrayList<Node> successorNodes = new ArrayList <Node>();
    for (Node child : allNodes) {
      if (parent.end == child.start) {
        successorNodes.add(child);
      }
    } 
    return successorNodes;
  }

  ArrayList<Node> findPath(Spot spot, Spot goal) {
    ArrayList <Node> agenda = new ArrayList<Node>();
    ArrayList <Node> visited = new ArrayList <Node>();
    ArrayList <Node> specificSuccessorNodes = new ArrayList <Node>();
    Node beginning = new Node(spot.locationPt, spot.locationPt, spot.road);
    PVector destinationPt = goal.locationPt;
    Node parent = null;
    agenda.add(beginning);
    visited.add(beginning);
    while (agenda.size() > 0) {
      parent = agenda.get(agenda.size()-1);
      agenda.remove(agenda.size()-1);
      specificSuccessorNodes = successors(parent);
      //println(specificSuccessorNodes);
      //println(allNodes);
      for (Node next : specificSuccessorNodes ) {
        if (next.start == destinationPt) {
          println("Path found");
          pathPresent = true;
          return agenda;
        } else if (visited.contains(next) == false) {
          agenda.add(next);
          visited.add(next);
        }
      }
    }
    println("No path found");
    return null;
  }


  // Creating ArrayList of all Nodes
  void addNodesToAllNodes(Roads roads1) {
    for (Road road : roads1.roads) {
      for (float t = 0.0; t<=1.0-(1.0/road.roadPts.length); t+=(1.0/road.roadPts.length)) {
        Node node1 = new Node(road.getPt(t), road.getNextPt(t), road);
        allNodes.add(node1);
      }
    }
  }
  void addNodeToAll(Node node) {
    allNodes.add(node);
  }

  void addNodeToPath(Node node) {
    pathOfNodes.add(node);
  }

  void drawPath(ArrayList<Node> path) {
    if (path != null) {
      for (Node node : path) {
        node.drawNode();
      }
    }
  }
}