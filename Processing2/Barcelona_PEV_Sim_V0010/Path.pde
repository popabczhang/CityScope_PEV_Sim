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
  int infinity = 999999999;

  Path(Nodes nodes) {
    pathOfNodes = new ArrayList <Node>();
  }

  // Successors function
  ArrayList <Node> successors(Node parent, Nodes nodes) {
    ArrayList<Node> successorNodes = new ArrayList <Node>();
    for (Node child : nodes.allNodes) {
      if (PVector.dist(parent.point, child.point) <= roadConnectionTolerance) {
        successorNodes.add(child);
      }
    } 
    return successorNodes;
  }


  // Path Algorithm

  int[] findPath(Spot start, Spot goal, Nodes nodes) {
    //int successorCount = 0;
    //int whileCount = 0;

    // Creation of parent array
    int [] parentArray = new int[nodes.allNodes.size()+1];
    for (Node node : nodes.allNodes) {
      parentArray[node.id] = infinity;
    }

    ArrayList <Node> agenda = new ArrayList<Node>();
    ArrayList <Node> specificSuccessorNodes = new ArrayList <Node>();
    Node beginning = null;
    Node end = null;
    // Finding the beginning node id
    for (Node node : nodes.allNodes) {
      if (node.point == start.locationPt) {
        beginning = node;
      }
      if (node.point == goal.locationPt) {
        end = node;
      }
    }

    PVector destinationPt = goal.locationPt;
    Node parent = null;
    if (beginning == null) {
      println("Beginning node not found in all nodes");
      return null;
    } else {
      agenda.add(beginning);
      while (agenda.size() > 0) {
        parent = agenda.get(0);
        agenda.remove(0);
        specificSuccessorNodes = successors(parent, nodes);
        //println(specificSuccessorNodes);
        //println(nodes.allNodes);

        //parent[child.id] = parent.id
        //parent of a child = parent

        for (Node next : specificSuccessorNodes ) {
          if (next.point == destinationPt) {
            println("Path found");
            pathPresent = true;
            parentArray[next.id] = parent.id;
            return parentArray;
          } else if (parentArray[next.id] == infinity) {
            agenda.add(next);
            parentArray[next.id] = parent.id;
          }
        }
      }
      println("No path found");
      println(destinationPt);
      return null;
    }
  }
  //Actually returning path (ArrayList of PVectors)
  ArrayList <PVector> pathFromParentArray(int [] parentArray, Spot start, Spot goal) {
    ArrayList<PVector> finalPath = new ArrayList <PVector>();
    PVector destinationPt = goal.locationPt;
    Node current = null;
    Node beginning = null;
    // Finding the final node id
    for (Node node : nodes.allNodes) {
      if (node.point == goal.locationPt) {
        current = node;
      }
      if (node.point == start.locationPt) {
        beginning = node;
      }
    }
    finalPath.add(destinationPt);
    if (current == null || beginning == null) {
      return null;
    } else {
      while (parentArray[current.id] != beginning.id) {
        int parentid = parentArray[current.id];
        //println(parentid);
        current = nodes.allNodes.get(parentid);
        finalPath.add(current.point);
      }
      //println(finalPath);
      return finalPath;
    }
  }
  void addNodeToPath(Node node) {
    pathOfNodes.add(node);
  }

  void drawAllPaths() {
    stroke(255, 0, 0); //cyan
    strokeWeight(1.0);
    for (int i = 0; i<=nodes.allNodes.size()-2; i++) {
      line(nodes.allNodes.get(i).point.x, nodes.allNodes.get(i).point.y, nodes.allNodes.get(i+1).point.x, nodes.allNodes.get(i+1).point.y);
    }
  }

  void drawPath(ArrayList<PVector> path) {
    stroke(0, 255, 0);
    strokeWeight(1.0);
    int total = path.size();
    for (int i = 0; i<= total-2; i++) {
      line(path.get(i).x, path.get(i).y, path.get(i+1).x, path.get(i+1).y);
    }
  }
}