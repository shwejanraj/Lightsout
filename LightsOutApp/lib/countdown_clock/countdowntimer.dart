import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'clock_painter.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({Key? key}) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.0),
      child: TweenAnimationBuilder<Duration>(
        duration: const Duration(minutes: 5),
        tween: Tween(begin: const Duration(minutes: 5), end: Duration.zero),
        onEnd: (){
          print("Completed");
        },
        builder: (BuildContext context, Duration value, Widget? child){
          final hours = value.inHours;
          final minutes = value.inMinutes;
          final seconds = value.inSeconds%60;

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black45
                            .withOpacity(0.2),
                        offset: const Offset(1.1, 4.0),
                        blurRadius: 8.0),
                  ],
                ),
                child: LiquidCircularProgressIndicator(
                  value: minutes*60/300, // Defaults to 0.5.
                  valueColor: const AlwaysStoppedAnimation(Colors.black,),
                  backgroundColor: Colors.grey,
                  borderColor: Colors.red.shade800,
                  borderWidth: 1.0,
                  direction: Axis.vertical,
                  center: Text(
                    minutes.toString().padLeft(2, '0') + ' : '+seconds.toString().padLeft(2, '0'),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              Container(
                height: 300,
                width: 300,
                // color: Colors.white,
                child: CustomPaint(
                  size: Size(250, 250),
                  painter: ClockPainter(
                      second: seconds,
                      minute: minutes,
                      hour: hours,
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}
