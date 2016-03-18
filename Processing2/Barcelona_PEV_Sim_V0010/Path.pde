// Barcelona PEV Simulation v0010
// for MIT Media Lab, Changing Place Group, CityScope Project

// by Udgam Goyal <udgam@mit.edu>
// Feb.8th.2015

class Path {
  ArrayList <Road> Roads;
  String roadPtFile;
  ArrayList <Node> pathOfNodes;
  boolean pathPresent = false;
  float roadConnectionTolerance = 10.0; //pxl; smaller than 1.0 will cause error

  Path() {
    pathOfNodes = new ArrayList <Node>();
  }

  // Successors function
  ArrayList <Node> successors(Node parent, Nodes nodes) {
    ArrayList<Node> successorNodes = new ArrayList <Node>();
    for (Node child : nodes.allNodes) {
      if (PVector.dist(parent.point,child.point) <= roadConnectionTolerance) {
        successorNodes.add(child);
      }
    } 
    return successorNodes;
  }

  ArrayList<Node> findPath(Spot spot, Spot goal, Nodes nodes) {
    //int successorCount = 0;
    //int whileCount = 0;
    ArrayList <Node> agenda = new ArrayList<Node>();
    ArrayList <Node> visited = new ArrayList <Node>();
    ArrayList <Node> specificSuccessorNodes = new ArrayList <Node>();
    Node beginning = new Node(spot.locationPt, -1, spot.road);
    PVector destinationPt = goal.locationPt;
    Node parent = null;
    agenda.add(beginning);
    visited.add(beginning);
    while (agenda.size() > 0) {
      parent = agenda.get(0);
      agenda.remove(0);
      specificSuccessorNodes = successors(parent, nodes);
      //println(specificSuccessorNodes);
      //println(nodes.allNodes);
      for (Node next : specificSuccessorNodes ) {
        if (next.point == destinationPt) {
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
    println(destinationPt);
    return null;
  }

  void addNodeToPath(Node node) {
    pathOfNodes.add(node);
  }

  void drawPath(ArrayList<Node> path) {
    if (path != null) {
      int len = path.size();
      for (int i = 0; i<=len-1; i++) {
        //node.drawNode();
      }
    }
  }
}