enum TrackingStatus { onTheWay, arrived }

class TrackingInfo {
  final double distanceInMeters;
  final int etaSeconds;
  final TrackingStatus status; // onTheWay | arrived

  TrackingInfo({
    required this.distanceInMeters,
    required this.etaSeconds,
    required this.status,
  });
}
