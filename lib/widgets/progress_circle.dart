import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressCircle extends StatelessWidget {
  final double progress; // 0-100
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final Widget? child;

  const ProgressCircle({
    super.key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 10,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景の円
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
              backgroundColor: Colors.transparent,
            ),
          ),
          // 進捗の円
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress / 100,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: Colors.transparent,
            ),
          ),
          // 中央のテキストまたは子ウィジェット
          if (child != null)
            child!
          else
            Text(
              '${progress.round()}%',
              style: TextStyle(
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
                color: progressColor,
              ),
            ),
        ],
      ),
    );
  }
} 