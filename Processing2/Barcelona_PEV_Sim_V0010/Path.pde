// Barcelona PEV Simulation v0010
// for MIT Media Lab, Changing Place Group, CityScope Project

// by Udgam Goyal <udgam@mit.edu>
// Feb.8th.2015

class Path{
   ArrayList <Road> Roads;
   String roadPtFile;
   ArrayList <Node> allNodes;
   ArrayList <Node> pathOfNodes;

Path(){
  allNodes = new ArrayList <Node>();
  pathOfNodes = new ArrayList <Node>();
}

// Successors function
ArrayList <Node> successors(Node parent){
  ArrayList<Node> successorNodes = new ArrayList <Node>();
  for (Node child: allNodes){
      if (parent.end == child.start){
          successorNodes.add(child);
      }
  } 
  return successorNodes;
}

void findPath(Spot spot, Spot goal){
        ArrayList <Node> agenda = new ArrayList<Node>();
        ArrayList <Node> visited = new ArrayList <Node>();
        Node beginning = new Node(null, spot.locationPt , spot.road);
        PVector destinationPt = goal.locationPt;
        Node parent = null;
        agenda.add(beginning);
        visited.add(beginning);
        while (agenda.size() > 0){
               parent = agenda.get(agenda.size()-1);
               agenda.remove(agenda.size()-1);
               ArrayList <Node> successorNodes = successors(parent);
               for (Node next: successorNodes ){
                   if (next.start == destinationPt){
                       pathOfNodes = agenda;
                   }

                   if (visited.contains(next) == false){
                       agenda.add(next);
                       visited.add(next);
                   }
               }
        
        }
        for(Node node : pathOfNodes){
        println(node.start);
        }
}


// Creating ArrayList of all Nodes
void addNodesToAllNodes(){
  for (Road road : Roads){
      for (float t = 0.0; t<=1.0-(1/road.roadPts.length); t+=(1/road.roadPts.length)){
        Node node1 = new Node(road.getPt(t), road.getNextPt(t), road);
        allNodes.add(node1);
      }

  }
}
void addNodeToAll(Node node) {
    allNodes.add(node);
  }

void addNodeToPath(Node node){
    pathOfNodes.add(node);
  }
  
void drawPath(ArrayList<Node> path) {
    for (Node node : path) {
      node.drawNode();
    }
}
}