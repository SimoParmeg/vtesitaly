import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/schedule_tile.dart';

class ScheduleRow extends StatefulWidget {

  const ScheduleRow({super.key});

  @override
  State<ScheduleRow> createState() => _ScheduleRowState();
}

class _ScheduleRowState extends State<ScheduleRow> {

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    
    return !isMobile ? Column(
      key: widget.key,
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageWidget(isMobile),
            _buildColumnWidget()       
          ]
        ),
      ],
    ) : Column(
      key: widget.key,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        _buildColumnWidget(),
        const SizedBox(height:20),
        _buildImageWidget(isMobile)
      ]
    );

  }

  Widget _buildTitleWidget(){
    return const Text(
      "Schedule",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    );
  }

Widget _buildColumnWidget() {
  return Expanded(
    child: ListView(
      shrinkWrap: true,
      children: [
        const ScheduleTile(
          icondata: Icon(Icons.access_alarm, color: Colors.white),
          title: "Registration time: ",
          time: "8:45-9:15",
          subtitle: "Please remember to send your decklist the day before the event!",
        ),
        ScheduleTile(
          icondata: _buildCircleWithText("1"),
          title: "First Round: ",
          time: "9:30-11:30"
        ),
        ScheduleTile(
          icondata: _buildCircleWithText("2"),
          title: "Second Round: ",
          time: "11:45- 13:45"
        ),
        const ScheduleTile(
          icondata: Icon(
            Icons.restaurant,
            color: Colors.white,
          ),
          title: "Lunch time: ",
          time: "13:45- 15:30"
        ),
        ScheduleTile(
          icondata: _buildCircleWithText("3"),
          title: "Third Round: ",
          time: "15:30-17:30"
        ),
        const ScheduleTile(
          icondata: Icon(
            Icons.emoji_events, 
            color: Colors.white),
          title: "Final Round: ",
          time: "18:00-20:00"
        ),
      ],
    ),
  );
}


  Widget _buildImageWidget(bool isMobile){
    
    return Image.asset(
      "assets/images/disguised.jpeg",
      width: !isMobile 
        ? min(500, MediaQuery.of(context).size.width/2-32) 
        : MediaQuery.of(context).size.width-32,
      height: !isMobile 
        ? min(500, MediaQuery.of(context).size.width/2-32) 
        : MediaQuery.of(context).size.width-32,
      fit: BoxFit.cover,
    );
  }


  Widget _buildCircleWithText(String number) {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      radius: 20,
      child: Text(
        number,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}