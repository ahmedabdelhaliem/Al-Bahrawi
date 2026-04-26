import 'package:base_project/common/resources/color_manager.dart';
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
        final pickupName = state.selectedPickup?.name ?? 'نقطة الركوب';

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'متجه إلى: $pickupName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.textColor,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              if (trackingInfo != null) ...[
                _buildInfoRow(
                  'المسافة المتبقية',
                  _formatDistance(trackingInfo.distanceInMeters),
                  Icons.map_outlined,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'الوقت المتوقع',
                  _formatDuration(trackingInfo.etaSeconds),
                  Icons.timer_outlined,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'الحالة',
                  trackingInfo.status == TrackingStatus.arrived
                      ? 'وصلت ✅'
                      : 'في الطريق 🚌',
                  Icons.info_outline,
                  valueColor: trackingInfo.status == TrackingStatus.arrived
                      ? ColorManager.successGreen
                      : ColorManager.primary,
                ),
                const SizedBox(height: 24),
              ],
              if (!isTracking)
                StartTrackingButton(
                  onPressed: () {
                    context.read<MapTrackingCubit>().startTracking();
                  },
                )
              else
                OutlinedButton(
                  onPressed: () {
                    context.read<MapTrackingCubit>().stopTracking();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: ColorManager.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'إيقاف التتبع',
                    style: TextStyle(
                      color: ColorManager.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, color: ColorManager.grey, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: ColorManager.grey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? ColorManager.textColor,
          ),
        ),
      ],
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toInt()} متر';
    }
    return '${(meters / 1000).toStringAsFixed(1)} كم';
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    if (minutes < 1) return 'أقل من دقيقة';
    return '$minutes دقيقة';
  }
}
