import 'dart:async';
import 'package:flutter/material.dart';

class DownloadUploadAnimation extends StatefulWidget {
  final Duration duration;

  DownloadUploadAnimation({required this.duration});

  @override
  _DownloadUploadAnimationState createState() =>
      _DownloadUploadAnimationState();
}

class _DownloadUploadAnimationState extends State<DownloadUploadAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Timer _timer;
  bool _isDownloading = true; // To toggle the direction

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _timer = Timer.periodic(widget.duration, (timer) {
      if (mounted) {
        setState(() {
          _isDownloading = !_isDownloading;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildArrow(
              color: _isDownloading ? Colors.black : Colors.green,
            ),
            SizedBox(width: 8),
            _buildArrow(
              color: _isDownloading ? Colors.green : Colors.black,
            ),
          ],
        );
      },
    );
  }

  Widget _buildArrow({required Color color}) {
    return Container(
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
