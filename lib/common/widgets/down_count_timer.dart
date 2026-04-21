
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountdownPage extends StatefulWidget {
  final int startMinutes;
  final int? id;

  const CountdownPage({super.key, required this.startMinutes, this.id});

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String get timerText {
    Duration duration = _controller.duration! * _controller.value;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    // instance<BookTripCubit>().duration = widget.startMinutes - int.parse(minutes);
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    final totalDuration = Duration(minutes: widget.startMinutes);
    _controller = AnimationController(
      vsync: this,
      duration: totalDuration,
    ); // Start countdown

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        // Timer finished
        // instance<BookTripCubit>().bookTrip(examId: widget.id ?? 0);
      }
    });

    _controller.reverse(from: 1.0);
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Text(
            timerText,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}
