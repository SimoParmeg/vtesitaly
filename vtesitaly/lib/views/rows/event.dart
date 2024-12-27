import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';

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
        formattedCountdown = "Event Started!";
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
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    
    return !isMobile ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColumnWidget(),
        _buildImageWidget(isMobile),
        
      ]
    ) : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageWidget(isMobile),
        const SizedBox(height:20),
        _buildColumnWidget()        
      ]
    );

  }

  Widget _buildColumnWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Italian ",
                style: TextStyle(
                  fontSize: 48, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: "Grand Prix ",
                style: TextStyle(
                  fontSize: 48, 
                  fontWeight: FontWeight.bold,
                  color: Colors.blue ,
                ),
              ),
              TextSpan(
                text: "2024-25",
                style: TextStyle(
                  fontSize: 48, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black, 
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16
        ),
        Text(
          "Modena, Italy", 
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w900,
            color: Colors.black.withOpacity(0.6)
          )
        ),
        const SizedBox(
          height: 4
        ),
        const Text(
          "March 1st, 2025", 
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w900,
            color: Colors.blue
          )
        ),
        const SizedBox(
          height: 12
        ),
        const Text(
          "Event starts in:", 
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w900,
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
            fontWeight: FontWeight.w800,
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
    );
  }

  Widget _buildImageWidget(bool isMobile){
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        "assets/images/logo_gp.jpeg",
        width: !isMobile 
          ? min(475, MediaQuery.of(context).size.width/2-32) 
          : MediaQuery.of(context).size.width-32,
        height: !isMobile 
          ? min(475, MediaQuery.of(context).size.width/2-32) 
          : MediaQuery.of(context).size.width-32,
        fit: BoxFit.cover,
      )
    );
  }
}