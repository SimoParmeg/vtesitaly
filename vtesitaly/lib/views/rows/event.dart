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
  String formattedCountdown = "";


  @override
  void initState() {
    super.initState();
    _startCountdown();
  }


  @override 
  void dispose() {
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
        formattedCountdown = "Evento Iniziato!";
      } else {
        final int totalDays = _remainingTime.inDays;
        final int years = totalDays ~/ 365;
        final int months = (totalDays % 365) ~/ 30;
        final int days = (totalDays % 365) % 30;
        final int hours = _remainingTime.inHours % 24;
        final int minutes = _remainingTime.inMinutes % 60;
        final int seconds = _remainingTime.inSeconds % 60;

        
        formattedCountdown = '${years > 0 ? "$years anni " : ""}'
            '${months > 0 ? "$months months " : ""}'
            '${days > 0 ? "$days days " : ""}'
            '${hours.toString().padLeft(2, '0')}:'
            '${minutes.toString().padLeft(2, '0')}:'
            '${seconds.toString().padLeft(2, '0')}';
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
              "Italian Grand Prix 2024-25", 
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
                color: Colors.blue
              )
            ),
            const SizedBox(
              height: 4
            ),
            const Text(
              "March 1st, 2025", 
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
              "Event starts in:", 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w300,
                color: Colors.black
              )
            ),
            const SizedBox(
              height: 20
            ),
            Text(
              formattedCountdown, 
              style: const TextStyle(
                fontSize: 25, 
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
                color: Colors.red
              )
            ),
          ],
        ),
        Image.asset(
          "assets/images/KarlSchrekt.jpeg",
          // width: MediaQuery.of(context).size.width/2-32,
          width: min(500, MediaQuery.of(context).size.width/2-32),
          height: min(500, MediaQuery.of(context).size.width/2-32),
          fit: BoxFit.cover,
        )
      ],
    );
  }
}