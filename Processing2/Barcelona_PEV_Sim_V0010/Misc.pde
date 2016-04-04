/*
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
  //println(PEVs.findNearestPEV(pickups.Spots.get(0).locationPt));
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


    // Finding path for each pair of spot and destination

    for (int i = 0; i< numberOfPaths; i++) {
      int [] p = new int[nodes.allNodes.size()];
      p = path.findPath(pickups.Spots.get(i), destinations.Spots.get(i), nodes);
      ArrayList <PVector> finalPath = path.pathFromParentArray(p, pickups.Spots.get(i), destinations.Spots.get(i));
      paths.add(finalPath);
      //println(p);
      if (!presenceOfPath && path.pathPresent) {
        presenceOfPath = true;
      }
    }
  }
  
  
  
  void move2() {
    if (inRoutePath != null) {
      // update the speed according to frameRate
      speedT = maxSpeedMPS / road.roadLengthMeter / frameRate; //speedT unit: t per frame
      if (inRoutePathCount > inRoutePath.size()-1) {
        inRoutePath = null;
        inRoutePathCount = 0;
      } else {

        // calc the next step
        if (inRoutePath.get(inRoutePathCount) == road.getPt(t+speedT)) {
          t = t + speedT;
        } else {
          t = t - speedT;
        }

        // if at end of road
        if (t > 1.0 || t < 0.0) {
          // simple test on one road
          //speedT = -speedT;

          // looking for all next road connected
          ArrayList<Road> nextRoads = new ArrayList<Road>();
          Road closest = new Road();
          //PVector roadEndPt = road.roadPts[road.ptNum-1];
          //PVector roadStartPt = road.roadPts[0];
          //int i = 0;
          for (Road tmpRoad : roads.roads) {
            PVector tmpRoadStartPt = tmpRoad.roadPts[0];
            //PVector tmpRoadEndPt = tmpRoad.roadPts[tmpRoad.ptNum-1];
            //println("tmpRoad ["+i+"]: ");
            //println("PVector.dist(roadEndPt, tmpRoadStartPt) = "+PVector.dist(roadEndPt, tmpRoadStartPt));
            //println("PVector.dist(roadStartPt, tmpRoadEndPt) = "+PVector.dist(roadStartPt, tmpRoadEndPt));
            float min = 1000.0;
            if (PVector.dist(inRoutePath.get(inRoutePathCount), tmpRoadStartPt) < min ) {
              min = PVector.dist(inRoutePath.get(inRoutePathCount), tmpRoadStartPt);
              closest = tmpRoad;
            }
          }
          // pick one next road
          //if (nextRoads.size() <= 0) {
          //  println("ERROR: CAN NOT FIND NEXT ROAD!" + 
          //    "THERE MUST BE DEADEND ROAD! CHECK ROAD RHINO FILE OR ROAD PT DATA TXT");
          //}
          //Road nextRoad = nextRoads.get(0);
          // switch current road to next road
          road = closest; 
          t = 0.0;
        }

        inRoutePathCount += 1;
      }
    }
  }
  void move3() {
    if (deliveringPath != null) {
      // update the speed according to frameRate
      speedT = maxSpeedMPS / road.roadLengthMeter / frameRate; //speedT unit: t per frame
      if (deliveringPathCount > deliveringPath.size()-1) {
        deliveringPath = null;
        deliveringPathCount = 0;
      } else {

        // calc the next step
        if (deliveringPath.get(deliveringPathCount) == road.getPt(t+speedT)) {
          t = t + speedT;
        } else {
          t = t - speedT;
        }

        // if at end of road
        if (t > 1.0 || t < 0.0) {
          // simple test on one road
          //speedT = -speedT;

          // looking for all next road connected
          ArrayList<Road> nextRoads = new ArrayList<Road>();
          Road closest = new Road();
          //PVector roadEndPt = road.roadPts[road.ptNum-1];
          //PVector roadStartPt = road.roadPts[0];
          //int i = 0;
          for (Road tmpRoad : roads.roads) {
            PVector tmpRoadStartPt = tmpRoad.roadPts[0];
            //PVector tmpRoadEndPt = tmpRoad.roadPts[tmpRoad.ptNum-1];
            //println("tmpRoad ["+i+"]: ");
            //println("PVector.dist(roadEndPt, tmpRoadStartPt) = "+PVector.dist(roadEndPt, tmpRoadStartPt));
            //println("PVector.dist(roadStartPt, tmpRoadEndPt) = "+PVector.dist(roadStartPt, tmpRoadEndPt));
            float min = 1000.0;
            if (PVector.dist(deliveringPath.get(deliveringPathCount), tmpRoadStartPt) < min ) {
              min = PVector.dist(deliveringPath.get(deliveringPathCount), tmpRoadStartPt);
              closest = tmpRoad;
            }
          }
          // pick one next road
          //if (nextRoads.size() <= 0) {
          //  println("ERROR: CAN NOT FIND NEXT ROAD!" + 
          //    "THERE MUST BE DEADEND ROAD! CHECK ROAD RHINO FILE OR ROAD PT DATA TXT");
          //}
          //Road nextRoad = nextRoads.get(0);
          // switch current road to next road
          road = closest; 
          t = 0.0;
        }

        deliveringPathCount += 1;
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  
  else if (inRoutePath != null) {
      if (inRoutePathCount<inRoutePath.size()) {
        locationPt = inRoutePath.get(inRoutePathCount);
        speedIRP += 1.0/60;
        inRoutePathCount = inRoutePathCount + int(speedIRP);
      } else {
        inRoutePathCount = 0;
        //inRoutePath = null;
      }
    } else if (deliveringPath != null) {
      if (deliveringPathCount<deliveringPath.size()) {
        locationPt = deliveringPath.get(deliveringPathCount);
        speedDP += 1.0/60;
        deliveringPathCount = deliveringPathCount + int(speedDP);
      } else {
        deliveringPathCount = 0;
        //deliveringPath = null;
      }
    }
  
  
  
  
  
  
*/