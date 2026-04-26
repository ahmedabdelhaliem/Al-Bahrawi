import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/resources/color_manager.dart';

import 'package:base_project/app/di.dart';
import '../../data/models/pickup_point_model.dart';
import '../cubit/map_tracking_cubit.dart';
import '../cubit/map_tracking_state.dart';
import 'widgets/recenter_button.dart';
import 'widgets/tracking_bottom_sheet.dart';

class MapTrackingView extends StatelessWidget {
  final PickupPointModel pickup;

  const MapTrackingView({super.key, required this.pickup});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<MapTrackingCubit>()..initialize(pickup),
      child: const _MapTrackingViewContent(),
    );
  }
}

class _MapTrackingViewContent extends StatelessWidget {
  const _MapTrackingViewContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: ColorManager.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MapTrackingCubit, MapTrackingState>(
        builder: (context, state) {
          if (state.isLoading || state.isInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: ColorManager.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'حدث خطأ ما',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MapTrackingCubit>().initialize(state.selectedPickup!);
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final Set<Marker> markers = {};
          final Set<Polyline> polylines = {};

          if (state.selectedPickup != null) {
            markers.add(
              Marker(
                markerId: const MarkerId('pickup_point'),
                position: LatLng(state.selectedPickup!.lat, state.selectedPickup!.lng),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                infoWindow: InfoWindow(title: state.selectedPickup!.name, snippet: 'نقطة الركوب (محطة الباص)'),
              ),
            );
          }

          // New Capital Destination Marker
          markers.add(
            Marker(
              markerId: const MarkerId('destination_new_capital'),
              position: const LatLng(30.0101, 31.6705), // Approximate New Capital coordinates
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: const InfoWindow(title: 'العاصمة الإدارية', snippet: 'الوجهة النهائية'),
            ),
          );

          if (state.polylinePoints.isNotEmpty) {
            polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                points: state.polylinePoints,
                color: ColorManager.primary,
                width: 5,
              ),
            );
          }

          final initialCameraPosition = state.userPosition != null
              ? CameraPosition(target: state.userPosition!, zoom: 14)
              : (state.selectedPickup != null
                  ? CameraPosition(
                      target: LatLng(state.selectedPickup!.lat, state.selectedPickup!.lng), zoom: 14)
                  : const CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 10));

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                polylines: polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                padding: const EdgeInsets.only(bottom: 300), // Adjusts map center and Google logo above the bottom sheet
                onMapCreated: (controller) {
                  context.read<MapTrackingCubit>().mapController = controller;
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      context.read<MapTrackingCubit>().recenterCamera();
                    }
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 16,
                        left: Directionality.of(context) == TextDirection.rtl ? 16 : 0,
                        right: Directionality.of(context) == TextDirection.rtl ? 0 : 16,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: RecenterButton(
                          onPressed: () {
                            context.read<MapTrackingCubit>().recenterCamera();
                          },
                        ),
                      ),
                    ),
                    const TrackingBottomSheet(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
