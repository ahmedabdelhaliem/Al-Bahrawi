import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:base_project/common/base/base_state.dart';

import '../../data/models/pickup_point_model.dart';
import '../../data/services/location_service.dart';
import '../../domain/entities/tracking_info.dart';
import 'map_tracking_state.dart';

class MapTrackingCubit extends Cubit<MapTrackingState> {
  final LocationService _locationService;
  StreamSubscription<Position>? _positionSubscription;
  GoogleMapController? mapController;
  final PolylinePoints _polylinePoints = PolylinePoints();

  // Replace this with a real key or fetch from config
  final String _googleMapsApiKey = "YOUR_GOOGLE_MAPS_API_KEY_HERE";

  MapTrackingCubit(this._locationService) : super(const MapTrackingState());

  Future<void> initialize(PickupPointModel pickup) async {
    emit(state.copyWith(status: Status.loading, selectedPickup: pickup));

    final hasPermission = await _locationService.requestPermission();
    if (!hasPermission) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Location permission denied. Cannot track your trip.',
      ));
      return;
    }

    final position = await _locationService.getCurrentPosition();
    if (position != null) {
      final userLatLng = LatLng(position.latitude, position.longitude);
      
      emit(state.copyWith(
        status: Status.success,
        userPosition: userLatLng,
      ));

      await _fetchPolyline(userLatLng, LatLng(pickup.lat, pickup.lng));
      _recalculateTrackingInfo(userLatLng, LatLng(pickup.lat, pickup.lng));
    } else {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Could not get current location.',
      ));
    }
  }

  void startTracking() {
    emit(state.copyWith(isTracking: true));
    
    _positionSubscription?.cancel();
    _positionSubscription = _locationService.positionStream.listen((Position position) {
      final userLatLng = LatLng(position.latitude, position.longitude);
      
      emit(state.copyWith(userPosition: userLatLng));
      
      if (state.selectedPickup != null) {
        final pickupLatLng = LatLng(state.selectedPickup!.lat, state.selectedPickup!.lng);
        _recalculateTrackingInfo(userLatLng, pickupLatLng);
      }
    });
  }

  void stopTracking() {
    emit(state.copyWith(isTracking: false));
    _positionSubscription?.cancel();
  }

  void recenterCamera() {
    if (mapController == null || state.userPosition == null || state.selectedPickup == null) return;
    
    final pickup = state.selectedPickup!;
    final userPos = state.userPosition!;
    
    LatLngBounds bounds;
    if (userPos.latitude > pickup.lat && userPos.longitude > pickup.lng) {
      bounds = LatLngBounds(southwest: LatLng(pickup.lat, pickup.lng), northeast: userPos);
    } else if (userPos.longitude > pickup.lng) {
      bounds = LatLngBounds(
        southwest: LatLng(userPos.latitude, pickup.lng),
        northeast: LatLng(pickup.lat, userPos.longitude),
      );
    } else if (userPos.latitude > pickup.lat) {
      bounds = LatLngBounds(
        southwest: LatLng(pickup.lat, userPos.longitude),
        northeast: LatLng(userPos.latitude, pickup.lng),
      );
    } else {
      bounds = LatLngBounds(southwest: userPos, northeast: LatLng(pickup.lat, pickup.lng));
    }
    
    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  Future<void> _fetchPolyline(LatLng origin, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: _googleMapsApiKey,
      request: PolylineRequest(
        origin: PointLatLng(origin.latitude, origin.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      // Fallback: draw straight line if API fails or no key
      polylineCoordinates = [origin, destination];
    }

    emit(state.copyWith(polylinePoints: polylineCoordinates));
  }

  void _recalculateTrackingInfo(LatLng userPos, LatLng pickupPos) {
    final double distanceInMeters = Geolocator.distanceBetween(
      userPos.latitude,
      userPos.longitude,
      pickupPos.latitude,
      pickupPos.longitude,
    );

    // Assuming average speed of 40 km/h (11.11 m/s)
    final int etaSeconds = (distanceInMeters / 11.11).round();
    
    final TrackingStatus trackingStatus = distanceInMeters < 50 ? TrackingStatus.arrived : TrackingStatus.onTheWay;
    
    final TrackingInfo info = TrackingInfo(
      distanceInMeters: distanceInMeters,
      etaSeconds: etaSeconds,
      status: trackingStatus,
    );

    emit(state.copyWith(data: info));
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }
}
