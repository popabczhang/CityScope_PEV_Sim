// Hamburg PEV Simulation v0010
// for MIT Media Lab, Changing Place Group, CityScope Project

// by Yan Zhang (Ryan) <ryanz@mit.edu>
// Dec.8th.2015

PFont myFont;
PImage img_BG;
//PGraphics pg;
String roadPtFile;
float screenScale;  //1.0F(for normal res or OS UHD)  2.0F(for WIN UHD)
int totalPEVNum = 10;
int totalSpotNum = 0;
int targetPEVNum;
int totalRoadNum;
float scaleMeterPerPixel = 2.15952; //meter per pixel in processing; meter per mm in rhino
float ScrollbarRatioPEVNum = 0.12;
float ScrollbarRatioPEVSpeed = 0.5;
float ScrollbarRatioProb = 0.25;
Roads roads;
Roads smallerSampleRoads;
PEVs PEVs;
Spots Spots;
boolean drawRoads = false;
boolean drawPath = false;
boolean drawTest = false;
ArrayList <ArrayList<PVector>> paths;
Path path;
Spots pickups;
Spots destinations;
int[] pickupsToSpots = new int[100000];
int[] destinationsToSpots = new int[100000];
Nodes nodes;
boolean presenceOfPath = false;
int time = 0;
int currentJob = 0;
ArrayList <Integer> currentPEVs = new ArrayList <Integer>();
int currentSpot = 0;
int currentPEV = -1;
int totalSpots = 0;
int pickupsIndex = 0;
int destinationsIndex = 0;
ArrayList <PVector> test, test2;
void setup() {
  size(1024, 1024); //1920 x 1920: screenScale is about 1.5
  screenScale = width / 1920.0; //fit everything with screen size
  scale(screenScale);
  println("width = "+width);
  println("screenScale = "+screenScale);

  //  pg = createGraphics(1920, 1920);

  setupScrollbars();

  smooth(8); //2,3,4, or 8

  img_BG = loadImage("BG_ALL_75DPI.png");

  // add roads
  roadPtFile = "RD_CRV_PTS_151231.txt";
  roads = new Roads();
  roads.addRoadsByRoadPtFile(roadPtFile);
  smallerSampleRoads = new Roads();
  smallerSampleRoads.roads.add(roads.roads.get(0));
  smallerSampleRoads.roads.add(roads.roads.get(1));
  //println(smallerSampleRoads.roads);


  // add PEVs
  PEVs = new PEVs();
  PEVs.initiate(totalPEVNum);

  //add od data
  String d = "oddata.tsv";
  Schedule schedule = new Schedule(d);
  //add Pickup Spots
  Spots = new Spots();
  //Spots.initiate(totalSpotNum);
  paths = new ArrayList<ArrayList<PVector>>();


  pickups = new Spots();
  destinations = new Spots();
  nodes = new Nodes();
  nodes.addNodesToAllNodes(roads);
  path = new Path(nodes);
}
void draw() {

  time += 1;
  //println("Pickups Size:" + pickups.Spots.size());
  //println("Destinations Size:" + destinations.Spots.size());
  // Getting a PEV to "pick up package"

  if (time % 300 == 0) {

    int prob = int(random(0, 100));
    if (prob <= ScrollbarRatioProb) {
      totalSpotNum = 2;
    }

    for (int i = 0; i <= totalSpotNum; i++) {
      Spots.initiate(1);
      Spot s = Spots.Spots.get(Spots.Spots.size()-1);
      if (s.status == 0) {
        pickups.addSpot(s);
        pickupsToSpots[pickupsIndex] = totalSpots;
        totalSpots += 1;
        pickupsIndex +=1;
      }

      if (s.status == 1) {
        destinations.addSpot(s);
        destinationsToSpots[destinationsIndex] = totalSpots;
        totalSpots += 1;
        destinationsIndex +=1;
      }
    }
    totalSpotNum = 0;

    while (pickups.Spots.size() > currentJob && destinations.Spots.size() > currentJob) {
      // Moving to starting location path
      currentPEVs.add(PEVs.findNearestPEV(pickups.Spots.get(currentJob).locationPt));
      PEVs.PEVs.get(currentPEVs.get(currentJob)).action = "inRoute";
      int [] p = path.findPath(PEVs.PEVs.get(currentPEVs.get(currentJob)).locationPt, pickups.Spots.get(currentJob).locationPt, nodes);
      PEVs.PEVs.get(currentPEVs.get(currentJob)).inRoutePath.pathOfNodes = path.pathFromParentArray(p, PEVs.PEVs.get(currentPEVs.get(currentJob)).locationPt, pickups.Spots.get(currentJob).locationPt);

      //test = PEVs.PEVs.get(currentPEV).inRoutePath.pathOfNodes;

      // Moving from start to finish path

      int [] p2 = path.findPath(pickups.Spots.get(currentJob).locationPt, destinations.Spots.get(currentJob).locationPt, nodes);
      PEVs.PEVs.get(currentPEVs.get(currentJob)).deliveringPath.pathOfNodes = path.pathFromParentArray(p2, pickups.Spots.get(currentJob).locationPt, destinations.Spots.get(currentJob).locationPt);
      //test2 = PEVs.PEVs.get(currentPEV).deliveringPath.pathOfNodes;
      paths.add(PEVs.PEVs.get(currentPEVs.get(currentJob)).deliveringPath.pathOfNodes);
      currentJob += 1;
      presenceOfPath = true;
    }
    if (currentPEVs.size() > 0) {
      int s = 0;
      for (int job : currentPEVs) {
        if (PEVs.PEVs.get(job).action == "wandering") {
          Spots.Spots.get(s).drawn = false;
          Spots.Spots.get(s+1).drawn = false;
          println(s);
          println("Removed");
          
          // 1, 2,3,4
          // 0,1,2,3,4,5,6,7
        }
        s = s + 2;
      }
    }
  }
  scale(screenScale);
  background(0);

  //  pg.beginDraw();
  //  pg.background(0);
  //  pg.stroke(255);
  //  pg.line(20, 20, mouseX, mouseY);

  imageMode(CORNER);

  image(img_BG, 0, 0, 1920, 1920);

  // draw roads
  if (drawRoads) {
    roads.drawRoads();
  }

  if (drawTest) {
    //for (int i = 0; i<= nodes.allNodes.size()-2; i++){
    path.drawAllPaths();
  }



  if (drawPath && presenceOfPath) {
    for (ArrayList<PVector> eachPath : paths) {
      path.drawPath(eachPath);
    }
  }






  // run PEVs
  PEVs.run();
  Spots.run();

  //  image(pg, 0, 0);

  // show frameRate
  //println(frameRate);
  textAlign(RIGHT);
  textSize(10*2/screenScale);
  fill(200);
  text("frameRate: "+str(int(frameRate)), 1620 - 50, 50);

  // draw scollbars
  drawScrollbars();
  targetPEVNum = int(ScrollbarRatioPEVNum*45+5); //5 to 50
  PEVs.changeToTargetNum(targetPEVNum);
  maxSpeedKPH = (ScrollbarRatioPEVSpeed*20+10)*10; //units: kph  10.0 to 50.0 kph
  maxSpeedMPS = maxSpeedKPH * 1000.0 / 60.0 / 60.0; //20.0 KPH = 5.55556 MPS
  maxSpeedPPS = maxSpeedMPS / scaleMeterPerPixel; 
  fill(255);
  noStroke();
  rect(260, 701, 35, 14);
  rect(260, 726, 35, 14);
  textAlign(LEFT);
  textSize(10);
  fill(200);
  text("mouseX: "+mouseX/screenScale+", mouseY: "+mouseY/screenScale, 10, 20);
  fill(0);
  text(targetPEVNum, 263, 712);
  text(int(maxSpeedKPH/10), 263, 736);
  text(int(ScrollbarRatioProb), 263, 760);
  //path.drawPath2(test);
  //path.drawPath2(test2);
}