import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class EventRow extends StatefulWidget {
  const EventRow({super.key});

  @override
  State<EventRow> createState() => _EventRowState();
}

class _EventRowState extends State<EventRow> {

  late Timer _timer;
  Duration _remainingTime = const Duration();
  final DateTime _targetDateTime = DateTime(2025, 3, 1, 9, 30, 0);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }


  @override void dispose() {
    _timer.cancel();
    super.dispose();
  }


  void _startCountdown() {
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }


  void _updateRemainingTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _remainingTime = _targetDateTime.difference(now);
      if (_remainingTime.isNegative) {
        _timer.cancel();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Italian Grand Prix Modena", 
              style: TextStyle(
                fontSize: 25, 
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(
              height: 16
            ),
            const Text(
              "2025", 
              style: TextStyle(
                fontSize: 40, 
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(
              height: 16
            ),
            const Text(
              "Modena, Italy", 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w300,
                color: Colors.grey
              )
            ),
            const SizedBox(
              height: 4
            ),
            const Text(
              "Modena, Italy", 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w300,
                color: Colors.blue
              )
            ),
            const SizedBox(
              height: 12
            ),
            const Text(
              "Countdown", 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w300,
                color: Colors.black
              )
            ),
            const SizedBox(
              height: 12
            ),
            Text(
              _remainingTime.toString(), 
              style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w300,
                color: Colors.black
              )
            ),
            const SizedBox(
              height: 12
            ),
            const Text(
              "Subscriptions Available Soon!", 
              style: TextStyle(
                fontSize: 30, 
                fontWeight: FontWeight.bold,
                color: Colors.black
              )
            ),
          ],
        ),
        Image.asset(
          "assets/images/vtes_italy.jpeg",
          // width: MediaQuery.of(context).size.width/2-32,
          width: min(500, MediaQuery.of(context).size.width/2-32),
          fit: BoxFit.cover,
        )
      ],
    );
  }
}