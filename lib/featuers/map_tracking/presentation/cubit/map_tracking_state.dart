import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/failure.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/pickup_point_model.dart';
import '../../domain/entities/tracking_info.dart';

class MapTrackingState extends BaseState<TrackingInfo> {
  final LatLng? userPosition;
  final List<LatLng> polylinePoints;
  final bool isTracking;
  final PickupPointModel? selectedPickup;

  const MapTrackingState({
    super.status = Status.initial,
    super.failure,
    super.errorMessage,
    super.data,
    super.items = const [],
    super.metadata = const {},
    this.userPosition,
    this.polylinePoints = const [],
    this.isTracking = false,
    this.selectedPickup,
  });

  @override
  MapTrackingState copyWith({
    Status? status,
    String? errorMessage,
    Failure? failure,
    TrackingInfo? data,
    List<TrackingInfo>? items,
    Map<String, dynamic>? metadata,
    LatLng? userPosition,
    List<LatLng>? polylinePoints,
    bool? isTracking,
    PickupPointModel? selectedPickup,
  }) {
    return MapTrackingState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      items: items ?? this.items,
      metadata: metadata ?? this.metadata,
      userPosition: userPosition ?? this.userPosition,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      isTracking: isTracking ?? this.isTracking,
      selectedPickup: selectedPickup ?? this.selectedPickup,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        userPosition,
        polylinePoints,
        isTracking,
        selectedPickup,
      ];
}
