import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';



class OtherEventsRow extends StatefulWidget {

  const OtherEventsRow({super.key});

  @override
  State<OtherEventsRow> createState() => _OtherEventsRowState();
}

class _OtherEventsRowState extends State<OtherEventsRow> {

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    
    return !isMobile ? Column(
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ]
        ),
      ],
    ) : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),

      ]
    );

  }


Widget _buildTitleWidget() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Side Events",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 36, 
          color: Colors.blue, 
          fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 8),
      Text(
        "In addition to the Grand Prix, we will hosting another event on Sunday, in the same place. Subscriptions on bcncrisis.com",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
      ),
    ],
  );
}
}