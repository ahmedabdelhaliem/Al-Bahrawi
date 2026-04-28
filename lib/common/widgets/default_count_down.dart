import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';

class DefaultCountdownWidget extends StatefulWidget {
  final String? startTime;
  final bool isNormalText;

  const DefaultCountdownWidget({super.key, this.startTime, this.isNormalText = false});

  @override
  State<DefaultCountdownWidget> createState() => _DefaultCountdownWidgetState();
}

class _DefaultCountdownWidgetState extends State<DefaultCountdownWidget> {
  late Duration duration;
  Timer? timer;

  Duration safeParseDuration(String? time) {
    if (time == null || time.trim().isEmpty) {
      return Duration.zero;
    }

    final cleaned = time.replaceAll(' ', '');

    final parts = cleaned.split(':');

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    try {
      if (parts.length == 1) {
        hours = int.parse(parts[0]);
      } else if (parts.length == 2) {
        hours = int.parse(parts[0]);
        minutes = int.parse(parts[1]);
      } else if (parts.length >= 3) {
        hours = int.parse(parts[0]);
        minutes = int.parse(parts[1]);
        seconds = int.parse(parts[2]);
      }
    } catch (_) {
      return Duration.zero;
    }

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }


  @override
  void initState() {
    super.initState();
    print(widget.isNormalText);
    if(!widget.isNormalText) {
      duration = safeParseDuration(widget.startTime);
      startTimer();
    }
  }

  void startTimer() {
    if (duration.inSeconds <= 0) return;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (duration.inSeconds > 0) {
        setState(() {
          duration -= const Duration(seconds: 1);
        });
      } else {
        timer?.cancel();
      }
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:"
        "${twoDigits(d.inMinutes.remainder(60))}:"
        "${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.isNormalText ? (widget.startTime??'') : formatDuration(duration),
      style: TextStyle(
        fontSize: widget.isNormalText ? 20.sp : 30.sp,
        color: ColorManager.primary,
        letterSpacing: widget.isNormalText ? null : 3.w,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
