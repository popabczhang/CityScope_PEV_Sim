// Barcelona PEV Simulation v0010
// for MIT Media Lab, Changing Place Group, CityScope Project

// by Udgam Goyal <udgam@mit.edu>
// Feb.8th.2015

class Path {
  ArrayList <Road> Roads;
  String roadPtFile;
  ArrayList <PVector> pathOfNodes;
  boolean pathPresent = false;
  float roadConnectionTolerance = .75; //pxl; smaller than 1.0 will cause error
  int infinity = 999999999;

  Path(Nodes nodes) {
    pathOfNodes = new ArrayList <PVector>();
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

  int[] findPath(PVector startPt, PVector goalPt, Nodes nodes) {
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
      if (node.point == startPt) {
        beginning = node;
      }
      if (node.point == goalPt) {
        end = node;
      }
    }

    PVector destinationPt = goalPt;
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
  ArrayList <PVector> pathFromParentArray(int [] parentArray, PVector startPt, PVector goalPt) {
    ArrayList<PVector> finalPath = new ArrayList <PVector>();
    PVector destinationPt = goalPt;
    Node current = null;
    Node beginning = null;
    // Finding the final node id
    for (Node node : nodes.allNodes) {
      if (node.point == goalPt) {
        current = node;
      }
      if (node.point == startPt) {
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
      ArrayList <PVector> inOrderPath = new ArrayList<PVector>();
      for (int i = finalPath.size()-1; i >= 0; i -= 1) {
        inOrderPath.add(finalPath.get(i));
      }
      pathOfNodes = inOrderPath;
      return pathOfNodes;
    }
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

  void drawPath2(ArrayList <PVector> path) {
    stroke(0, 255, 0);
    fill(0, 255, 0);
    for (PVector p : path) {
      ellipse(p.x, p.y, 10, 10);
    }
  }
  
  PVector getTangentVector(int _n) {
    int n = _n;
    int l = pathOfNodes.size();
    if ( n < 0 || n >= l ) {
      println("\"n\" out of range!");
      return null;
    } else if (n == l - 1) {
      PVector v1 = pathOfNodes.get(n-1);
      PVector v2 = pathOfNodes.get(n);
      PVector v3 = PVector.sub(v2, v1);
      v3.normalize();
      return  v3;
    } else {
      PVector v1 = pathOfNodes.get(n);
      PVector v2 = pathOfNodes.get(n+1);
      PVector v3 = PVector.sub(v2, v1);
      v3.normalize();
      return  v3;
    }
  }

}