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
int totalSpotNum = 4;
int targetPEVNum;
int totalRoadNum;
float scaleMeterPerPixel = 2.15952; //meter per pixel in processing; meter per mm in rhino
float ScrollbarRatioPEVNum = 0.12;
float ScrollbarRatioPEVSpeed = 0.5;
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
Nodes nodes;
boolean presenceOfPath = false;
int time = 0;
int currentJob = 0;
int currentPEV;
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
  Spots.initiate(totalSpotNum);

  pickups = new Spots();
  destinations = new Spots();
  nodes = new Nodes();
  nodes.addNodesToAllNodes(roads);
  path = new Path(nodes);

  // Checking how many pairs of pickups and destinations exist

  for (Spot spot : Spots.Spots) {
    if (spot.status == 0) {
      pickups.addSpot(spot);
    }

    if (spot.status == 1) {
      destinations.addSpot(spot);
    }
  }
  println(pickups.Spots.size());
  println(PEVs.findNearestPEV(pickups.Spots.get(0).locationPt));
  println(destinations.Spots.size());


  // Creating Paths

  if (pickups.Spots.size() >= 1 && destinations.Spots.size() >= 1 ) {
    paths = new ArrayList<ArrayList<PVector>>();
    int numberOfPaths = 0;
    if (pickups.Spots.size() < destinations.Spots.size()) {
      numberOfPaths = pickups.Spots.size();
    } else {
      numberOfPaths = destinations.Spots.size();
    }
    println(numberOfPaths);
  }
   
   // Moving to starting location path
   
   currentPEV = PEVs.findNearestPEV(pickups.Spots.get(0).locationPt);
   PEVs.PEVs.get(currentPEV).makeFull();
   int [] p = path.findPath(PEVs.PEVs.get(currentPEV).locationPt,pickups.Spots.get(0).locationPt, nodes);
   PEVs.PEVs.get(currentPEV).inRoutePath = path.pathFromParentArray(p, PEVs.PEVs.get(currentPEV).locationPt,pickups.Spots.get(0).locationPt);
   
   // Moving from start to finish path
   
  int [] p2 = path.findPath(pickups.Spots.get(0).locationPt,destinations.Spots.get(0).locationPt, nodes);
  PEVs.PEVs.get(currentPEV).deliveringPath = path.pathFromParentArray(p2, pickups.Spots.get(0).locationPt,destinations.Spots.get(0).locationPt);
}

void draw() {
  
  time += 1;

  // Getting a PEV to "pick up package"



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
  
  
}