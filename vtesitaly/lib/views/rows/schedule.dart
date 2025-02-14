import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/schedule_tile.dart';
import 'package:vtesitaly/views/components/section_title.dart';

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
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildImageWidget(isMobile),
            _buildColumnWidget(isMobile)
          ]
        ),
      ],
    ) : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        _buildColumnWidget(isMobile),
        const SizedBox(height:20),
        _buildImageWidget(isMobile)
      ]
    );

  }

  Widget _buildTitleWidget() {
    return const SectionTitle(
      title: "Schedule",
    );
  }

Widget _buildColumnWidget(bool isMobile) {
  return SizedBox(
    height: 550,
    width: !isMobile ? 480 : MediaQuery.of(context).size.width,
    child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 17.0),
          child: ScheduleTile(
            icondata: Icon(Icons.access_alarm, color: Colors.white),
            title: "Registration time: ",
            time: "8:45-9:15",
            subtitle: "Please remember to send your decklist the day before the event!",
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 17.0),
          child: ScheduleTile(
            icondata: _buildCircleWithText("1"),
            title: "First Round: ",
            time: "9:30-11:30"
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 17.0),
          child: ScheduleTile(
            icondata: _buildCircleWithText("2"),
            title: "Second Round: ",
            time: "11:45- 13:45"
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 17.0),
          child: ScheduleTile(
            icondata: Icon(
              Icons.restaurant,
              color: Colors.white,
            ),
            title: "Lunch time: ",
            time: "13:45- 15:30"
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 17.0),
          child: ScheduleTile(
            icondata: _buildCircleWithText("3"),
            title: "Third Round: ",
            time: "15:30-17:30"
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 17.0),
          child: ScheduleTile(
            icondata: Icon(
              Icons.emoji_events, 
              color: Colors.white),
            title: "Final Round: ",
            time: "18:00-20:00"
          ),
        ),
      ],
    ),
  );
}


  Widget _buildImageWidget(bool isMobile){
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        "assets/images/disguised.jpeg",
        width: !isMobile 
          ? min(480, MediaQuery.of(context).size.width/2-32) 
          : MediaQuery.of(context).size.width-32,
        height: !isMobile 
          ? min(480, MediaQuery.of(context).size.width/2-32) 
          : MediaQuery.of(context).size.width-32,
        fit: BoxFit.cover,
      )
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