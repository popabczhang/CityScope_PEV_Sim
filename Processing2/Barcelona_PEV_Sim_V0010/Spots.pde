// Barcelona PEV Simulation v0010
// for MIT Media Lab, Changing Place Group, CityScope Project

// by Udgam Goyal <udgam@mit.edu>
// Feb.8th.2015


class Spots {

  ArrayList<Spot> Spots;
  //int currentPEVID;

  Spots() {
    Spots = new ArrayList<Spot>();
  }

  void initiate(int _totalSpotNum) {

    int totalSpotNum = _totalSpotNum;
    for (int i = 0; i < totalSpotNum; i ++) {
      int tmpRoadID = int(random(0.0, totalRoadNum-1)+0.5);
      Road tmpRoad = roads.roads.get(tmpRoadID);
      float t = random(0.0, 0.75);
      //PEV tmpPEV = new PEV(currentPEVID, tmpRoadID, t);
      Spot tmpSpot = new Spot(tmpRoad, t);
      Spots.add(tmpSpot);

    }

  }

  void run() {
    for (Spot Spot : Spots) {
      Spot.run();
    }
  }

  void addSpot(Spot _spot) {
    Spots.add(_spot);
  }

  void addRandomly() {
    int tmpRoadID = int(random(0.0, totalRoadNum-1)+0.5);
    Road tmpRoad = roads.roads.get(tmpRoadID);
    float t = random(0.0, 0.75);
    Spot tmpSpot = new Spot(tmpRoad, t);
    Spots.add(tmpSpot);
  }

  void removeRandomly() {
    int n = int(random(0, Spots.size()-1));
    Spots.remove(n);
  }

  void changeToTargetNum(int _targetNum) {
    int tn = _targetNum;
    int cn = Spots.size();
    if (cn>tn) {
      removeRandomly();
    } else if (cn<tn) {
      addRandomly();
    }
  }
}