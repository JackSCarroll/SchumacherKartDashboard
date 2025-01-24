
class SessionData {
  final double avgSpeed;
  final String totalTime;
  final double totalDistance;
  List<double> sectorTimes;

  SessionData({required this.avgSpeed, required this.totalTime, required this.totalDistance, this.sectorTimes = const []});
  
  void addSectorTime(double time) {
    sectorTimes.add(time);
  }

}