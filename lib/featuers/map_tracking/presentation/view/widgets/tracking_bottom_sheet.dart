import 'package:base_project/common/resources/color_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/tracking_info.dart';
import '../../cubit/map_tracking_cubit.dart';
import '../../cubit/map_tracking_state.dart';
import 'start_tracking_button.dart';

class TrackingBottomSheet extends StatelessWidget {
  const TrackingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapTrackingCubit, MapTrackingState>(
      builder: (context, state) {
        final trackingInfo = state.data;
        final isTracking = state.isTracking;
        final pickupName = state.selectedPickup?.name ?? AppStrings.pickupPoint.tr();

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header Row: Name
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pickupName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          AppStrings.pickupPoint.tr(),
                          style: const TextStyle(color: ColorManager.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              // Info Pills Row
              if (trackingInfo != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      _buildInfoPill(
                        _formatDistance(trackingInfo.distanceInMeters),
                        Icons.directions_bus_filled_outlined,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoPill(
                        _formatDuration(trackingInfo.etaSeconds),
                        Icons.access_time_rounded,
                      ),
                    ],
                  ),
                ),
              // Action Button (Full Width)
              SizedBox(
                width: double.infinity,
                child: !isTracking
                    ? StartTrackingButton(
                        onPressed: () {
                          context.read<MapTrackingCubit>().startTracking();
                        },
                      )
                    : _buildSecondaryButton(
                        label: AppStrings.stopTracking.tr(),
                        icon: Icons.stop_circle_outlined,
                        color: ColorManager.red,
                        onTap: () {
                          context.read<MapTrackingCubit>().stopTracking();
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCircleIcon(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: ColorManager.primary, size: 22),
      ),
    );
  }

  Widget _buildInfoPill(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ColorManager.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorManager.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: ColorManager.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: ColorManager.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toInt()} ${AppStrings.meters.tr()}';
    }
    return '${(meters / 1000).toStringAsFixed(1)} ${AppStrings.km.tr()}';
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    if (minutes < 1) return AppStrings.lessThanMinute.tr();
    return '$minutes ${AppStrings.minuteUnit.tr()}';
  }
}
